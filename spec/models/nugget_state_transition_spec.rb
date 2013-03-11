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

require 'spec_helper'

describe NuggetStateTransition do
  pending "add some examples to (or delete) #{__FILE__}"
end
