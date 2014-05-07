# encoding: utf-8
namespace :db do
  desc "Fülle die Datenbank mit Beispieldaten"
  task populate: :environment do
    admin = User.create!(name: "Admin Benutzer",
                login: "admin",
                email: "beispiel@beispiel.de",
                password: "foobar",
                password_confirmation: "foobar")
    admin.toggle!(:admin)

    99.times do |n|
      titel = Faker::Lorem.sentence
      slug = Faker::Lorem.sentence.parameterize + "-" + n.to_s
      inhalt = Faker::Lorem.paragraphs(paragraph_count = 4 )
      user = User.find(1)
      blogpost = user.blogposts.build(titel: titel,
                  url_slug: slug,
                  inhalt: inhalt)
      blogpost.save
  end

    99.times do |n|
      name = Faker::Name.name
      login = "beispiel-#{n+1}"
      email = "beispiel-#{n+1}@beispiel.de"
      password = "password"
      User.create!(name: name,
                  email: email,
                  login: login,
                  password: password,
                password_confirmation: password)
    end
end
end
