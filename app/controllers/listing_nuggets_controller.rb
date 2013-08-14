class ListingNuggetsController < ApplicationController
  def update

  end
  def add_attachment
    begin
      @listing_nugget = ListingNugget.find(params[:listing_nugget_id])
      @broker_email_attachment = BrokerEmailAttachment.find(params[:broker_email_attachment_id])
      unless @listing_nugget.broker_email_attachment_ids.include?(@broker_email_attachment.id)
        @listing_nugget.broker_email_attachments << @broker_email_attachment
      end
      render :nothing=> true, status: 200
    rescue
      render :nothing=> true, status: 500
    end
  end
end
