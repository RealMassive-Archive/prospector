class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
  end

  def index2
  end

  def index3
  end

  def dashboard
    @nuggets = Nugget.all
    @signage_received_nuggets = Nugget.signage_received
    @signage_review_check_nuggets = Nugget.signage_review_check
    @no_gps_nuggets = Nugget.no_gps
    @signage_reviewable_nuggets = Nugget.signage_reviewable
    @blurry_nuggets = Nugget.blurry
    @inappropriate_nuggets = Nugget.inappropriate
    @rejected_nuggets = Nugget.reject_signage_review
    @ready_to_contact_broker_nuggets = Nugget.ready_to_contact_broker
    @broker_contacted_nuggets = Nugget.broker_contacted
  end

end
