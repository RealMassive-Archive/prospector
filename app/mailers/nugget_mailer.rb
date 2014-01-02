class NuggetMailer < ActionMailer::Base
  default from: "RealMassive Prospector <nugget@realmassive.com>"
  default :"reply-to" => "no-reply@realmassive.com"

  def nugget_rejected(reason, nugget)
    @reason = reason
    @nugget = nugget
    mail to: nugget.submitter, subject: "[Prospector] Nugget Rejected: #{reason}"
  end

  def image_store_fail(nugget)
    admin = (ENV['ADMIN_EMAIL'] || "joshua@realmassive.com") # Fallback to Joshua McClure if no admin found
    @nugget = nugget
    mail to: "#{admin},#{nugget.submitter}", subject: "[Prospector] Images could not be saved for nugget ID #{nugget.id}"
  end
end