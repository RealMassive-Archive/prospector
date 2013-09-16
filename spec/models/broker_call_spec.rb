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

require 'spec_helper'

describe BrokerCall do
  pending "add some examples to (or delete) #{__FILE__}"
end
