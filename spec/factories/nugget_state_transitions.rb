# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nugget_state_transition do
    nugget nil
    event "MyString"
    from "MyString"
    to "MyString"
    created_at "2013-03-10 13:09:45"
  end
end
