class SignageMailer < ActionMailer::Base
  default from: "nugget@realmassive.com"
  default :"reply-to" => "no-reply@realmassive.com"

  def success_signage_receipt(nugget, subject)
    @nugget = nugget
    @subject = subject
    mail(
      to: nugget.submitter,
      subject: "[RECEIVED] Re: " + subject
      )
  end

  def no_gps_signage_receipt(nugget, subject)
    @nugget = nugget
    @subject = subject
    mail(
      to: nugget.submitter,
      subject: "[NO GPS] Re: " + subject
      )
  end
end
