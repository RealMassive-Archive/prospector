class ApiListingsController < ApplicationController

  def new
    # Spits out a form for now, that's about it.
    @building = Building.new
  end

end
