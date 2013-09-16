# == Schema Information
#
# Table name: broker_emails
#
#  id                     :integer          not null, primary key
#  nugget_id              :integer
#  from                   :string(255)
#  to                     :string(255)
#  subject                :string(255)
#  body                   :text
#  review_reason          :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  parsed                 :boolean          default(FALSE)
#  spam                   :boolean          default(FALSE)
#  need_supervisor_review :boolean          default(FALSE)
#

require 'spec_helper'

describe BrokerEmail do
  pending "add some examples to (or delete) #{__FILE__}"
end
