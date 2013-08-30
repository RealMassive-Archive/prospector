class ListingsController < ApplicationController

  def extract_listing
    @listing_nugget = ListingNugget.listing_nuggets_of_parsed_broker_emails.first
    @broker_email = @listing_nugget.broker_email
    @nugget = @broker_email.nugget
    @listing = Listing.new
    render :layout => false
  end

  def create
    @listing = Listing.create(params[:listing])
    render :text => @listing.to_json
  end
end
