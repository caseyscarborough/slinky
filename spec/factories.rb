FactoryGirl.define do
  factory :user do
    first_name "Casey"
    last_name "Scarborough"
    email "casey@caseyscarborough.com"
    password "password"
    password_confirmation "password"
  end
end