class ListingsController < ApplicationController

  # POST /listings
  # POST /listings.json
  def index
    @listings = Listing.all
  end

  def extract_listing
    @listing_nugget = ListingNugget.listing_nuggets_of_parsed_broker_emails.first
    @broker_email = @listing_nugget.broker_email
    @nugget = @broker_email.nugget
    @listing = Listing.new
    render :layout => false
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(params[:listing])

    if @listing.save
      @listing.listing_nugget.update_attribute(:listing_extracted, true)
      #if attachments are an broker email attachment
      if params["email_attachment_ids"] && params["email_attachment_ids"].strip != ""
        arr = params["email_attachment_ids"].split(";")
        arr.each do |a|
          email_attachment = BrokerEmailAttachment.find(a)
          attachment = ListingAttachmentUploader.new
          attachment.cache!(File.open("#{email_attachment.file.current_path}"))
          attach = ListingAttachment. create(
              :listing_id=> @listing.id,
              :file=> attachment
          )
        end
      # if attachments are nugget attachments
      elsif params["nugget_attachment_ids"] && params["nugget_attachment_ids"].strip != ""
        arr = params["nugget_attachment_ids"].split(";")
        arr.each do |a|
          nugget_signage = NuggetSignage.find(a)
          attachment = ListingAttachmentUploader.new
          attachment.cache!(File.open("#{nugget_signage.signage.current_path}"))
          attach = ListingAttachment. create(
              :listing_id=> @listing.id,
              :file=> attachment
          )
        end
      end
    end
    redirect_to :back
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

end
