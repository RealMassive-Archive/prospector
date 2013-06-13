class Duplicate < ActiveRecord::Base
  attr_accessible :nugget_id, :compared_to_nugget_id,:duplicate_status
  belongs_to :nugget
  belongs_to :compared_to_nugget,:class_name=>"Nugget"
end
