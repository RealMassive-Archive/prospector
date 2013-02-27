# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nugget do
    state "MyString"
    latitude "9.99"
    longitude "9.99"
    submitter "MyString"
    submission_method "MyString"
    submission_on "2013-02-27 10:53:49"
  end
end
