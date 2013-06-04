class Duplicate < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :nugget
  belongs_to :duplicate_nugget,:class_name=>"Nugget"
  scope :pending, where(:duplicate_status=> nil)
end
