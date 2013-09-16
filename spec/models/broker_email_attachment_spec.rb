# == Schema Information
#
# Table name: broker_email_attachments
#
#  id              :integer          not null, primary key
#  broker_email_id :integer
#  file            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe BrokerEmailAttachment do
  pending "add some examples to (or delete) #{__FILE__}"
end
