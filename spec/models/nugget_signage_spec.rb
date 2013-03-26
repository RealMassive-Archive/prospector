# == Schema Information
#
# Table name: nugget_signages
#
#  id         :integer          not null, primary key
#  nugget_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  signage    :string(255)
#

require 'spec_helper'

describe NuggetSignage do
  pending "add some examples to (or delete) #{__FILE__}"
end
