class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :final_check, only: :purge
  skip_before_filter :cheap_authentication, only: :purge

  def index
    # For now, just lists available actions. Nothing
    # of consequence going on in this action.
  end

  #
  # This method added at request of RealMassive
  # project management in spite of warnings.
  # If at any point in the future this CAN be
  # removed or done in a more secure way, by all means,
  # DO IT!
  #
  def purge
    # Wipes the database model-by-model. Really, really
    # bad way to do things but explicitly requested.
    # Actual work gets done inside a resque worker and is
    # just queued here, assuming the user supplies the
    # correct password.
    unless Resque.enqueue(PurgeWorker)
      redirect_to admin_path, notice: "Could not enqueue purge request. Try again."
    end
  end

private

  def final_check
    if ["staging", "production"].include?(Rails.env)
      authenticate_or_request_with_http_basic "RealMassive Prospector" do |u,p|
        u == ENV['PURGE_USERNAME'] && p == ENV['PURGE_PASSWORD']
      end
    end

    # Make sure params[:purge_confirm] exists and is valid
    unless params[:purge_confirm] && params[:purge_confirm].strip.downcase == 'purge'
      redirect_to admin_path, notice: "Failed purge confirm test. Type the text correctly."
      return false
    end
  end

end
