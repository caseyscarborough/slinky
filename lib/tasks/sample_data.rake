require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    Faker::Config.locale = :en

    # Generate first user, typically the one you'll use.
    User.create(
      first_name: 'Casey', 
      last_name: 'Scarborough',
      email: 'casey@caseyscarborough.com',
      password: 'password',
      password_confirmation: 'password'
    )

    # Create sample users in the system.
    10.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = "#{first_name.downcase}@#{last_name.downcase}.com"
      
      puts "Generating user #{email}..."
      User.create(
        first_name: first_name, 
        last_name: last_name,
        email: email,
        password: 'password',
        password_confirmation: 'password'
      )
    end
    
    # Create links for each user in the system.
    puts 'Generating links...'
    User.all.each do |user|     
      15.times do |n|
        user.links.create!(
          short_url: Link.generate_short_link, 
          long_url: "http://" + Faker::Internet.domain_name, 
          total_clicks: rand(0..15),
          last_visited: rand(0..365).days.ago
        )
      end
    end

    puts "Complete."
  end
end