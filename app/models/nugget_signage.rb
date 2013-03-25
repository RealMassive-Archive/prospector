# == Schema Information
#
# Table name: nugget_signages
#
#  id         :integer          not null, primary key
#  nugget_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NuggetSignage < ActiveRecord::Base
  belongs_to :nugget
  mount_uploader :signage, NuggetSignageUploader

  attr_accessible :signage, :nugget_id

end
