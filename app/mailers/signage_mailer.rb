class SignageMailer < ActionMailer::Base
  default from: "RealMassive Prospector <nugget@realmassive.com>"
  default :"reply-to" => "no-reply@realmassive.com"

  def success_signage_receipt(nugget, subject)
    @nugget = nugget
    @subject = subject
    mail(
      to: nugget.submitter,
      subject: "[Prospector] Received: " + subject
      )
  end

  def no_gps_signage_receipt(nugget, subject)
    @nugget = nugget
    @subject = subject
    mail(
      to: nugget.submitter,
      subject: "[Prospector] No GPS with submission: " + subject
      )
  end

  # Message to be delivered when no attachment is with the image.
  def no_attachment(to, subject)
    @subject = subject
    mail(to: to, subject: "[Prospector] No attachment with submission #{subject}")
  end
end
