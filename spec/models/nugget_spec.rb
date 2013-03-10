# == Schema Information
#
# Table name: nuggets
#
#  id                   :integer          not null, primary key
#  state                :string(255)
#  latitude             :decimal(, )
#  longitude            :decimal(, )
#  submitter            :string(255)
#  submission_method    :string(255)
#  submitted_at         :datetime         not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  approx_address       :string(255)
#  nugget_type          :string(255)
#  nugget_phone         :string(255)
#  signage              :string(255)
#  signage_address      :string(255)
#  signage_city         :string(255)
#  signage_state        :string(255)
#  signage_county       :string(255)
#  signage_neighborhood :string(255)
#  editable_until       :datetime
#

require 'spec_helper'

describe Nugget do
  pending "add some examples to (or delete) #{__FILE__}"
end
