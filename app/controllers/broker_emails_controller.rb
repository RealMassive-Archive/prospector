class BrokerEmailsController < ApplicationController

  #Get /broker_emails/parse_broker_email
  def parse
    @nugget = Nugget.parse_info_from_broker_emails_jobs.first
    @broker_email = @nugget.broker_emails.not_parsed.first
    @listing_nuggets = @broker_email.listing_nuggets
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
