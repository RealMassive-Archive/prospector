class NuggetsController < ApplicationController
  before_filter :authenticate_user!

  # GET /nuggets
  # GET /nuggets.json
  def index

    # Basic guard against invalid parameters for sorting.
    # The view needs to know the opposite of the current sort order to generate the right links.
    # The view also has to know what you're currently sorting by so it can highlight the right field.
    @sort_column = (%w(submitter updated_at state).select { |x| x == params[:sort_column] }).first || "updated_at"
    @sort_order  = (%w(ASC DESC).select { |x| x == params[:sort_order] }).first || "ASC"

    @nuggets = Nugget.unscoped.where('state NOT IN (?)', [:duplicate, :no_gps, :signage_rejected, :blurry, :inappropriate]).
      where("signage_address IS NOT NULL").
      order("#{@sort_column} #{@sort_order}").paginate(:page => params[:page], :per_page => 20)
      # This order clause may look susceptible to SQL injection, but above I'm explicitly checking for specific
      # values in these fields and absolutely no other value, including anything with quotes, commas, dashes,
      # semicolons, etc.

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nuggets }
    end
  end

  # GET /nuggets/1
  # GET /nuggets/1.json
  def show
    @nugget = Nugget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nugget }
    end
  end

  def transition
    raise "no event provided" unless params[:state].present? and params[:event].present?
    @nugget = Nugget.with_state(params[:state]).last
    @nugget.user = current_user
    if @nugget.send(params[:event].to_sym)
      flash[:notice] = "Nugget successfully transitioned via event #{params[:event]} to state #{@nugget.state}."
    else
      flash[:error] = "Nugget in state #{params[:state]} cannot perform event #{params[:event]}."
    end
    redirect_to dashboard_path
  end

  # GET /nuggets/read_signage
  def read_signage
    @nugget = Nugget.read_signage_jobs.first
    if @nugget.nil?
      flash[:notice] = "No Signage jobs available."
      redirect_to jobboard_path
    else
      @nugget.set_editable_time
      @nugget.save
      render :layout => false
    end
  end

  # PUT /nuggets/1/update_signage
  # PUT /nuggets/1/update_signage.json
  def update_signage
    @nugget = Nugget.find(params[:id])
    @nugget.unset_editable_time

    respond_to do |format|
      if @nugget.update_attributes(params[:nugget])
        @nugget.signage_review!

        # JAH - Jan 7 2014
        # There used to be a state here to "review" signage that isn't
        # necessary. Ergo we're going to transition the nugget immediately
        # from signage_review to signage_approve to move it further along.
        @nugget.signage_approve!

        format.html { redirect_to jobboard_path, notice: 'Read Signage Job completed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to jobboard_path, error: 'Something went wrong. Job not completed.' }
        format.json { render json: @nugget.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /nuggets/1/tag_as_blurry
  def tag_as_blurry
    @nugget = Nugget.find(params[:id])
    @nugget.unset_editable_time
    @nugget.signage_tag_list = "blurry"
    @nugget.signage_review! # Spoof the state machine to thinking it's been reviewed, quick hack
    @nugget.signage_reject! # Reject it.
    @nugget.save
    NuggetMailer.nugget_rejected("Image is too blurry", @nugget).deliver
    redirect_to jobboard_path, flash: { notice: "That nugget was rejected because it's too blurry and the submitter has been notified." }
  end

  # GET /nuggets/1/tag_as_inappropriate
  def tag_as_inappropriate
    @nugget = Nugget.find(params[:id])
    @nugget.unset_editable_time
    @nugget.signage_tag_list = "inappropriate"
    @nugget.signage_review! # Spoof the state machine to let us reject it
    @nugget.signage_reject! # Actually reject it
    @nugget.save
    NuggetMailer.nugget_rejected("Image is inappropriate", @nugget).deliver
    redirect_to jobboard_path, flash: { notice: "That nugget was rejected because it's inappropriate and the submitter has been notified." }
  end

  # GET /nuggets/review_signage
  def review_signage
    @nugget = Nugget.review_signage_jobs.first
    if @nugget.nil?
      flash[:notice] = "No Review jobs available."
      redirect_to jobboard_path
    else
      @nugget.set_editable_time
      @nugget.save
      render :layout => false
    end
  end

  # GET /nuggets/1/approve_signage
  def approve_signage
    @nugget = Nugget.find(params[:id])
    @nugget.unset_editable_time
    if @nugget.signage_tag_list.include? 'blurry'
      @nugget.blurry!
    elsif @nugget.signage_tag_list.include? 'inappropriate'
      @nugget.inappropriate!
    else
      @nugget.signage_approve!
    end
    #@nugget.save
    #redirect_to jobboard_path
    render :nothing => true
  end

  # GET /nuggets/1/reject_signage
  def reject_signage
    @nugget = Nugget.find(params[:id])
    @nugget.unset_editable_time
    @nugget.signage_reject!
    #@nugget.save
    #redirect_to jobboard_path
    render :nothing => true
  end

  # GET /nuggets/1/unset_editable_time
  def unset_editable_time
    @nugget = Nugget.find(params[:id])
    @nugget.unset_editable_time
    @nugget.save
    #redirect_to jobboard_path
    render :nothing => true
  end

  # GET /nuggets/contact_broker
  def contact_broker
    @nugget = Nugget.contact_broker_jobs.first
    if @nugget.nil?
      flash[:notice] = "No Contact Broker jobs available."
      render :text=> "No contact broker jobs available"
    else
      @name = @nugget.contact_broker_fake_name
      @email = @nugget.contact_broker_fake_email
      # note that we should be comparing to existing open "broker contacted" or "ready to contact broker" nuggets to see if this email has been assigned to any open jobs. If so, then re-generate it till it's unique.
      # once the job comes back adn this nugget is no longer in ready to contact broker state, then the uniqueness of this doesn't matter (might be worth keeping for some tracking reason later, therefore not enforcing uniqueness in the DB)

      @address = @nugget.signage_address.nil? ? "{unknown]" : @nugget.signage_address.split(',').first
      @city = @nugget.signage_city
      @listing_type = @nugget.signage_listing_type.nil? ? "sale or maybe lease" : @nugget.signage_listing_type
      @nugget.set_editable_time
      @nugget.save
      @broker_call=BrokerCall.new
      render :layout => false
    end
  end

  # GET /nuggets/dedup_signage
  def dedupe_signage
    @nugget = Nugget.dedupe_jobs.first
    unless @nugget.nil?
      @nugget.set_editable_time
      @nugget.save
    end
    render layout: false
  end
  #Post /nuggets/:id/dedupe
  def dedupe
    @nugget = Nugget.find(params[:id])
    @compared_to_nugget= Nugget.find(params[:duplicate])
    @duplicate = Duplicate.find_or_initialize_by_nugget_id_and_compared_to_nugget_id(
        @nugget.id,
        @compared_to_nugget.id
    ).tap do |a|
      a.duplicate_status = params[:duplicate_status]
      a.user_id = current_user.id
    end.save!
    if params[:duplicate_status] == "match"
      @nugget.signage_duplicate
    end
   render layout: false
  end

  #Get /nuggets/:id/signage_unique
  def signage_unique
    @nugget = Nugget.find(params[:id])
    @nugget.unset_editable_time
    @nugget.signage_unique
    redirect_to jobboard_path
  end

  #Post /nuggets/:id/save_call
  def save_call
    @nugget=Nugget.where(:id=>params[:id]).first
    @broker_call=@nugget.broker_calls.new(params[:broker_call])
    @broker_call.caller = current_user
    respond_to do |format|
      if @broker_call.save
        @nugget.broker_contacted
        format.html { redirect_to jobboard_path, notice: 'Broker contacted.' }
        format.json { head :no_content }
      else
        @nugget.unset_editable_time
        format.html { redirect_to jobboard_path, notice: 'Something went wrong. Broker call not saved.' }
        format.json { render json: @nugget.errors, status: :unprocessable_entity }
      end
    end
  end

end
