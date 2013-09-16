# == Schema Information
#
# Table name: listing_nuggets
#
#  id                   :integer          not null, primary key
#  broker_email_id      :integer
#  broker_email_to      :string(255)
#  broker_email_from    :string(255)
#  broker_email_subject :string(255)
#  broker_email_body    :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  listing_extracted    :boolean          default(FALSE)
#

class ListingNugget < ActiveRecord::Base
  attr_accessible :broker_email_id, :broker_email_to, :broker_email_from,:broker_email_subject,:broker_email_body,:listing_extracted
  belongs_to :broker_email
  has_and_belongs_to_many :broker_email_attachments
  scope :listing_nuggets_of_parsed_broker_emails,joins(:broker_email).where("listing_extracted = ? AND broker_emails.parsed=?", false, true)

end
