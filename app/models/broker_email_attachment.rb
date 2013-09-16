# == Schema Information
#
# Table name: broker_email_attachments
#
#  id              :integer          not null, primary key
#  broker_email_id :integer
#  file            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class BrokerEmailAttachment < ActiveRecord::Base
  attr_accessible :file,:broker_email_id
  belongs_to :broker_email
  has_and_belongs_to_many :listing_nuggets
  mount_uploader :file, BrokerEmailAttachmentUploader
end
