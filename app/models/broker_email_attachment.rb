class BrokerEmailAttachment < ActiveRecord::Base
  attr_accessible :file,:broker_email_id
  belongs_to :broker_email
  has_and_belongs_to_many :listing_nuggets
  mount_uploader :file, BrokerEmailAttachmentUploader
end
