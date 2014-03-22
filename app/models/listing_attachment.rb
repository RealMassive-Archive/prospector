# == Schema Information
#
# Table name: listing_attachments
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  file       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ListingAttachment < ActiveRecord::Base
  attr_accessible :listing_id, :file
  belongs_to :listing
  mount_uploader :file, ListingAttachmentUploader
end
