class BrokerEmailsController < ApplicationController

  #Get /broker_emails/parse_broker_email
  def parse
    @nugget = Nugget.parse_info_from_broker_emails_jobs.first
    @broker_email = @nugget.broker_emails.not_parsed.first
    @nuggets=@broker_email.created_nuggets
    render layout: false
  end

  def add_nugget_tab
    @broker_email = BrokerEmail.find(params[:id])
    @nugget = @broker_email.created_nuggets.new(
        :broker_email_from => @broker_email.from,
        :broker_email_to => @broker_email.to,
        :broker_email_subject => @broker_email.subject,
        :broker_email_body => @broker_email.body,
        :submission_method => "parse_email"
    )
    @nugget.save
    @tab_id = @nugget.id
  end
end
