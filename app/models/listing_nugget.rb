class ListingNugget < ActiveRecord::Base
  attr_accessible :broker_email_id, :broker_email_to, :broker_email_from,:broker_email_subject,:broker_email_body
  belongs_to :broker_email
  has_and_belongs_to_many :broker_email_attachments
end
