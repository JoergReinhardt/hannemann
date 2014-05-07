# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = Users.create([{ name: "Admin Benutzer",
                        login: "admin",
                        email: "admin@test.de",
                        password: "foobar",
                        password_confirmation: "foobar"
                      }])
posts = Blogposts.create({{ titel: "titel 1",
                            url_slug: "titel-1",
                            inhalt: "lorem ipsum sit..."
                          }})
