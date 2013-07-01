FactoryGirl.define do
  factory :user do
    first_name "Casey"
    last_name "Scarborough"
    email "casey@caseyscarborough.com"
    password "password"
    password_confirmation "password"
  end

  factory :link do
    short_url "short"
    long_url "http://google.com"
    total_clicks 0
    last_visited nil
    user
  end
end