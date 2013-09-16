class ListingsController < ApplicationController

  # POST /listings
  # POST /listings.json
  def index
    @count = Listing.all.count
    @listings = Listing.order("updated_at DESC").paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
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
          if Rails.env.development? || Rails.env.test?
            attachment = ListingAttachmentUploader.new
            attachment.cache!(File.open("#{email_attachment.file.current_path}"))
            attach = ListingAttachment. create(
                :listing_id=> @listing.id,
                :file=> attachment
            )
          else
            attachment = @listing.listing_attachments.new
            attachment.remote_file_url = email_attachment.file.url
            attachment.save
          end
        end
      # if attachments are nugget attachments
      elsif params["nugget_attachment_ids"] && params["nugget_attachment_ids"].strip != ""
        arr = params["nugget_attachment_ids"].split(";")
        arr.each do |a|
          nugget_signage = NuggetSignage.find(a)
          if Rails.env.development? || Rails.env.test?
            attachment = ListingAttachmentUploader.new
            attachment.cache!(File.open("#{nugget_signage.signage.current_path}"))
            attach = ListingAttachment. create(
                :listing_id=> @listing.id,
                :file=> attachment
            )
          else
            attachment = @listing.listing_attachments.new
            attachment.remote_file_url = nugget_signage.signage.url
            attachment.save
          end
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
