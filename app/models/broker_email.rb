class BrokerEmail < ActiveRecord::Base
  attr_accessible :nugget_id,:from,:to,:subject,:body,:spam,:need_supervisor_review,:review_reason
  belongs_to :nugget
  has_many   :broker_email_attachments,:dependent => :destroy
  has_many   :created_nuggets,class_name: "Nugget",foreign_key: "origination_email_id"
  has_many   :listing_nuggets

  validates :nugget_id, :from, :to, presence: true

  scope :not_parsed, -> {where(parsed: false)}
end
