class ListingAttachment < ActiveRecord::Base
   attr_accessible :listing_id, :file
  belongs_to :listing
  mount_uploader :file, ListingAttachmentUploader
end
