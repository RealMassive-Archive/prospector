class BrokerEmailAttachment < ActiveRecord::Base
  attr_accessible :file,:broker_email_id
  belongs_to :broker_email
  mount_uploader :file, BrokerEmailAttachmentUploader
end
