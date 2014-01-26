class BrokerNotificationsMailer < ActionMailer::Base
  default from: "nuggetfund.com@realmassive.com"

  def submission_rejected(broker_email)
    @to = broker_email.from
    @approx_address = broker_email.nugget.signage_address
    mail to: @to, subject: "Could you please provide more details?", reply_to: broker_email.nugget.contact_broker_fake_email
  end
end