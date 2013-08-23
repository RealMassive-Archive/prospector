class ListingsController < ApplicationController

  def extract_listing
    @listing = Listing.new
    render :layout => false
  end
end
