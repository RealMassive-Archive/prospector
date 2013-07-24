class BrokerEmail < ActiveRecord::Base
  attr_accessible :nugget_id,:from,:to,:subject,:body,:spam,:need_supervisor_review,:review_reason
  belongs_to :nugget
  has_many   :broker_email_attachments,:dependent => :destroy
  validates :nugget_id, :from, :to, presence: true
end
