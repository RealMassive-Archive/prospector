class BrokerCall < ActiveRecord::Base
  attr_accessible :call_result, :call_comments, :broker_name,:broker_email
  belongs_to :nugget
  belongs_to :caller,:class_name => "User"
  validates :caller_id, presence: true
  validates :call_result, presence: true
end
