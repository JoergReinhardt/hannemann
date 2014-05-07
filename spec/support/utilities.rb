# encoding: utf-8

def full_title(page_title)
  base_title = "Uli Hannemann blökt"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
end

def sign_in(user)
  visit signin_path
  fill_in "Login", with: user.login
  fill_in "Passwort", with: user.password
  click_button "Anmelden"
  cookies[:remember_token] = user.remember_token
end
