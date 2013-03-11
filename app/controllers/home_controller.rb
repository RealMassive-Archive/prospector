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
    @initial_nuggets = Nugget.initial
    @signage_received_nuggets = Nugget.signage_received
    @signage_reviewed_nuggets = Nugget.signage_reviewed
    @no_gps_nuggets = Nugget.no_gps
    @blurry_nuggets = Nugget.blurry
    @inappropriate_nuggets = Nugget.inappropriate
    @rejected_nuggets = Nugget.signage_rejected
    @ready_to_contact_broker_nuggets = Nugget.ready_to_contact_broker
    @awaiting_broker_response_nuggets = Nugget.awaiting_broker_response
  end

end
