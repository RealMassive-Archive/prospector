class ListingNuggetsController < ApplicationController
  def update
    @listing_nugget = ListingNugget.find(params[:id])

    respond_to do |format|
      if @listing_nugget.update_attributes(params[:listing_nugget])
        format.html { redirect_to @listing_nugget, notice: 'Nugget was successfully updated.' }
        format.json { head :no_content }
        format.js {render nothing: true}
      else
        format.html { render action: "edit" }
        format.json { render json: @nugget.errors, status: :unprocessable_entity }
        format.js {render nothing: true,status: 500}
      end
    end
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
