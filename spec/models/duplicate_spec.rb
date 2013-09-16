# == Schema Information
#
# Table name: duplicates
#
#  id                    :integer          not null, primary key
#  nugget_id             :integer
#  compared_to_nugget_id :integer
#  user_id               :integer
#  duplicate_status      :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe Duplicate do
  pending "add some examples to (or delete) #{__FILE__}"
end
