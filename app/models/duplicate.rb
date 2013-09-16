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

class Duplicate < ActiveRecord::Base
  attr_accessible :nugget_id, :compared_to_nugget_id,:duplicate_status
  belongs_to :nugget
  belongs_to :compared_to_nugget,:class_name=>"Nugget"
end
