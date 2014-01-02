class NuggetMailer < ActionMailer::Base
  default from: "RealMassive Prospector <nugget@realmassive.com>"
  default :"reply-to" => "no-reply@realmassive.com"

  def nugget_rejected(reason, nugget)
    @reason = reason
    @nugget = nugget
    mail to: nugget.submitter, subject: "[Prospector] Nugget Rejected: #{reason}"
  end
end