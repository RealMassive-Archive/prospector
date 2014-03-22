class BuildingsController < ApplicationController

  def index
    @buildings = Building.all # TODO: Paginate
  end

  def new
    @building = Building.new
  end

  def create
    # TODO: creation logic
  end

  def search
    # Utilize the search method to find the building based on submitted address
    # parameters.
    @results = Building.search({
      city: params[:city],
      state: params[:state][0..1].upcase, # first two, uppercased
      zipcode: params[:zipcode],
      street: params[:street]
    })

    render json: Yajl::Encoder.encode(@results)
  end

end
