# encoding: utf-8
FactoryGirl.define do
  factory :user do
    sequence(:name)      { |n| "Name #{n}" }
    sequence(:login)     { |n| "Login #{n}" }
    sequence(:email)     { |n| "Login_#{n}@beispiel.de" }
    password  "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :blogpost do
    sequence(:titel)    { |n| "Blogpost #{n}" }
    sequence(:url_slug)    { |n| "blogpsot-#{n}" }
    inhalt "Lorem Ipsum sit dolor amed…"
    user
  end
end
