# == Schema Information
#
# Table name: listing_nuggets
#
#  id                   :integer          not null, primary key
#  broker_email_id      :integer
#  broker_email_to      :string(255)
#  broker_email_from    :string(255)
#  broker_email_subject :string(255)
#  broker_email_body    :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  listing_extracted    :boolean          default(FALSE)
#

require 'spec_helper'

describe ListingNugget do
  pending "add some examples to (or delete) #{__FILE__}"
end
