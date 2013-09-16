# == Schema Information
#
# Table name: broker_emails
#
#  id                     :integer          not null, primary key
#  nugget_id              :integer
#  from                   :string(255)
#  to                     :string(255)
#  subject                :string(255)
#  body                   :text
#  review_reason          :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  parsed                 :boolean          default(FALSE)
#  spam                   :boolean          default(FALSE)
#  need_supervisor_review :boolean          default(FALSE)
#

class BrokerEmail < ActiveRecord::Base
  attr_accessible :nugget_id,:from,:to,:subject,:body,:spam,:need_supervisor_review,:review_reason,:parsed
  belongs_to :nugget
  has_many   :broker_email_attachments,:dependent => :destroy
  has_many   :created_nuggets,class_name: "Nugget",foreign_key: "origination_email_id"
  has_many   :listing_nuggets

  validates :nugget_id, :from, :to, presence: true

  scope :not_parsed, -> {where(parsed: false,:spam => false,:need_supervisor_review => false)}
  scope :parsed, -> {where(parsed: true)}
  scope :spam, -> {where(spam: true)}
  scope :need_supervisor_review, -> {where(:need_supervisor_review => true)}
end
