class NuggetsController < ApplicationController
  before_filter :authenticate_user!

  # GET /nuggets
  # GET /nuggets.json
  def index
    @count = Nugget.all.count
    @nuggets = Nugget.paginate(:page => params[:page], :per_page => 12)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nuggets }
    end
  end

  # def index2
  #   @count = Nugget.where(is_new_multisignage_nugget: [false,nil] ).count
  #   @nuggets = Nugget.where(is_new_multisignage_nugget: [false,nil] ).paginate(:page => params[:page], :per_page => 20)

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @nuggets }
  #   end
  # end

  # GET /nuggets/1
  # GET /nuggets/1.json
  def show
    @nugget = Nugget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nugget }
    end
  end

  # GET /nuggets/new
  # GET /nuggets/new.json
  def new
    @nugget = Nugget.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nugget }
    end
  end

  # GET /nuggets/1/edit
  def edit
    @nugget = Nugget.find(params[:id])
  end

  # POST /nuggets
  # POST /nuggets.json
  def create
    @nugget = Nugget.new(params[:nugget])

    respond_to do |format|
      if @nugget.save
        format.html { redirect_to @nugget, notice: 'Nugget was successfully created.' }
        format.json { render json: @nugget, status: :created, location: @nugget }
      else
        format.html { render action: "new" }
        format.json { render json: @nugget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nuggets/1
  # PUT /nuggets/1.json
  def update
    @nugget = Nugget.find(params[:id])

    respond_to do |format|
      if @nugget.update_attributes(params[:nugget])
        format.html { redirect_to @nugget, notice: 'Nugget was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nugget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nuggets/1
  # DELETE /nuggets/1.json
  def destroy
    @nugget = Nugget.find(params[:id])
    @nugget.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
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
    @nugget.signage_review!
    @nugget.save
    redirect_to jobboard_path
  end

  # GET /nuggets/1/tag_as_inappropriate
  def tag_as_inappropriate
    @nugget = Nugget.find(params[:id])
    @nugget.unset_editable_time
    @nugget.signage_tag_list = "inappropriate"
    @nugget.signage_review!
    @nugget.save
    redirect_to jobboard_path
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
      redirect_to jobboard_path
    else
      fake = Faker::Name.name
      @name = fake
      @email = (fake.gsub(" ", ".") + "@nuggetfund.com").downcase
      # note that we should be comparing to existing open "broker contacted" or "ready to contact broker" nuggets to see if this email has been assigned to any open jobs. If so, then re-generate it till it's unique.
      # once the job comes back adn this nugget is no longer in ready to contact broker state, then the uniqueness of this doesn't matter (might be worth keeping for some tracking reason later, therefore not enforcing uniqueness in the DB)

      @address = @nugget.signage_address.nil? ? "{unknown]" : @nugget.signage_address.split(',').first
      @city = @nugget.signage_city
      @listing_type = @nugget.signage_listing_type.nil? ? "sale or maybe lease" : @nugget.signage_listing_type
      @nugget.set_editable_time
      @nugget.save
      render :layout => false
    end
  end

  # GET /nuggets/dedup_signage
  def dedupe_signage
    @nugget = Nugget.dedupe_jobs.first
    render layout: false
  end
  def dedupe
    @nugget = Nugget.find(params[:id])
    @duplicate_nugget= Nugget.find(params[:duplicate])
    @duplicate = Duplicate.find_or_initialize_by_nugget_id_and_duplicate_nugget_id(
        @nugget.id,
        @duplicate_nugget.id
    ).tap do |a|
      a.duplicate_status = params[:duplicate_status]
    end.save!
    if params[:duplicate_status] == "match"
      @nugget.signage_duplicate
    end
   render layout: false
  end
  def signage_unique
    @nugget = Nugget.find(params[:id])
    @nugget.signage_unique
    redirect_to jobboard_path
  end
end
