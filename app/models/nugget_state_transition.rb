class NuggetStateTransition < ActiveRecord::Base
  belongs_to :nugget
  attr_accessible :created_at, :event, :from, :to
end
