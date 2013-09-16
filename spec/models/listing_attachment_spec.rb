# == Schema Information
#
# Table name: listing_attachments
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  file       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe ListingAttachment do
  pending "add some examples to (or delete) #{__FILE__}"
end
