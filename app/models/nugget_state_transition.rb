# == Schema Information
#
# Table name: nugget_state_transitions
#
#  id            :integer          not null, primary key
#  nugget_id     :integer
#  event         :string(255)
#  from          :string(255)
#  to            :string(255)
#  created_at    :datetime
#  state_message :string(255)
#

class NuggetStateTransition < ActiveRecord::Base
  belongs_to :nugget
  attr_accessible :created_at, :event, :from, :to, :state_message, :nugget_id
end
