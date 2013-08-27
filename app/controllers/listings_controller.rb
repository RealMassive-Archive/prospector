class ListingsController < ApplicationController

  def extract_listing
    @listing_nugget = ListingNugget.listing_nuggets_of_parsed_broker_emails.first
    @broker_email = @listing_nugget.broker_email
    @listing = Listing.new
    render :layout => false
  end
end
