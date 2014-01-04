class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :cheap_authentication # See rationale in method comments

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end


  #rescue_from ActionController::RoutingError, :with => :render_not_found

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_not_found
    render :template => "/errors/404"
  end

private

  #
  # cheap_authentication
  #
  # The point of this method is to prevent total access to the app from
  # the public at large. The problem is that, as of 3 Dec 2014, the app
  # is built to let anybody sign up and start administering the queue.
  # There are plans to re-write this app in the future, so instead of
  # investing lots of time and money in rebuilding this to be more
  # "correct", this is just a cheap way to get some basic pseudo-security
  # so at least nobody's pants are down. It's a pair of cheap jeans, not
  # kevlar body armor.
  #
  def cheap_authentication
    authenticate_or_request_with_http_basic "RealMassive Prospector" do |u,p|
      u == ENV['CHEAP_AUTH_USERNAME'] && p == ENV['CHEAP_AUTH_PASSWORD']
    end
  end

end
