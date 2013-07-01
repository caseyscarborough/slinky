require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    User.create(first_name:"Casey", last_name:"Scarborough",
                email: "caseyscarborough@gmail.com",
                password: "password",
                password_confirmation: "password")

    users = User.all(limit: 3)
    50.times do
      short_url = Faker::Lorem.word
      long_url = "http://" + Faker::Internet.domain_name
      begin
        users.each { |user| user.links.create!(short_url: short_url, long_url: long_url, total_clicks: 0)}
      rescue
        next
      end
    end

  end
end