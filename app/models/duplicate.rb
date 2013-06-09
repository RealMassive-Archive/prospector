class Duplicate < ActiveRecord::Base
  attr_accessible :nugget_id, :duplicate_nugget_id,:duplicate_status
  belongs_to :nugget
  belongs_to :duplicate_nugget,:class_name=>"Nugget"
end
