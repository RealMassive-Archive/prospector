class BrokerEmailsController < ApplicationController
  before_filter :authenticate_user!

  # DELETE /broker_emails/:id
  def destroy
    be = BrokerEmail.find(params[:id])
    if Resque.enqueue(BrokerNotificationsWorker, be.id)
      redirect_to jobboard_path, notice: "Broker Email rejected and notice sent."
    else
      redirect_to jobboard_path, warning: "Not able to delete Broker Email and/or notify broker. Check logs. Broker email id: #{be.id}"
    end
  end

  #Get /broker_emails/parse_broker_email
  def parse

    @broker_email = BrokerEmail.not_parsed.first
    @nugget = @broker_email.nugget
    if @broker_email && @nugget
      @listing_nuggets = @broker_email.listing_nuggets
    else
      render :text => "No Emails to parse"
      return
    end

    render layout: false
  end

  def add_nugget_tab
    @broker_email = BrokerEmail.find(params[:id])
    @listing_nugget = @broker_email.listing_nuggets.new(
        :broker_email_from => @broker_email.from,
        :broker_email_to => @broker_email.to,
        :broker_email_subject => @broker_email.subject,
        :broker_email_body => @broker_email.body
    )
    @listing_nugget.save
    @tab_id = @listing_nugget.id
  end

  def update
    @broker_email = BrokerEmail.find(params[:id])

    respond_to do |format|
      if @broker_email.update_attributes(params[:broker_email])
        format.html { redirect_to root_path, notice: 'Broker Email was successfully parsed.' }
        format.json { head :no_content }
        format.js {render nothing: true}
      else
        format.html { render action: "edit" }
        format.json { render json: @broker_email.errors, status: :unprocessable_entity }
        format.js {render nothing: true,status: 500}
      end
    end
  end
end
