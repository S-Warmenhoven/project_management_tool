# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = "banana"  

# User.delete_all 
# Project.delete_all 
# Task.delete_all
# Discussion.delete_all
# Comment.delete_all 

User.destroy_all 
Project.destroy_all 
Task.destroy_all
Discussion.destroy_all
Comment.destroy_all 

super_user = User.create( 
    first_name: "Steph", 
    last_name: "Me", 
    email: "steph_war@yahoo.ca", 
    password: PASSWORD,
    is_admin: true
) 

10.times do 
    first_name = Faker::Name.first_name 
    last_name = Faker::Name.last_name 
    User.create( 
        first_name: first_name, 
        last_name: last_name,  
        email: "#{first_name.downcase}.#{last_name.downcase}@example.com", 
        password: PASSWORD 
    )  
end 

users = User.all 


20.times do
    user = users.sample
    p = Project.create(
        title: Faker::Job.field,
        description: Faker::Job.title,
        due_date: Faker::Date.between(from: 60.days.from_now, to: 90.days.from_now),
        user: user
    )
    if p.valid?
        rand(0..20).times.each do
            user = users.sample
            t = Task.create(
                title: Faker::Verb.past_participle,
                due_date: Faker::Date.between(from: Date.today, to: 60.days.from_now),
                body: Faker::Verb.past_participle,
                is_done: [true, false].sample,
                user: user,
                project: p
            )
        end

        rand(0..20).times.each do
            user = users.sample
            d = Discussion.create(
                title: Faker::TvShows::Simpsons.location,
                description: Faker::TvShows::Simpsons.quote,
                user: user,
            )
        
            if d.valid?
                users.shuffle.slice(0..rand(users.count)).each do |user|
                    Comment.create(
                      body: Faker::TvShows::Simpsons.quote,
                      user: user,
                      discussion: d
                    )
                end
            end
        end
    end
end

puts Cowsay.say("Generated #{Project.count} projects", :cow)
puts Cowsay.say("Generated #{Task.count} tasks", :frogs)
puts Cowsay.say("Generated #{Discussion.count} discussions", :ghostbusters)
puts Cowsay.say("Generated #{Comment.count} comments", :dragon)
puts Cowsay.say("Created #{User.count} users", :tux)  
puts "Login with #{super_user.email} and password of '#{PASSWORD}'"
