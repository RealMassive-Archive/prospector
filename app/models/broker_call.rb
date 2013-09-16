# == Schema Information
#
# Table name: broker_calls
#
#  id            :integer          not null, primary key
#  caller_id     :integer
#  nugget_id     :integer
#  call_result   :string(255)
#  call_comments :string(255)
#  broker_name   :string(255)
#  broker_email  :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class BrokerCall < ActiveRecord::Base
  attr_accessible :call_result, :call_comments, :broker_name,:broker_email
  belongs_to :nugget
  belongs_to :caller,:class_name => "User"
  validates :caller_id, presence: true
  validates :call_result, presence: true
end
