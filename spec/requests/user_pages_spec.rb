# encoding: utf-8
require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index Seite" do

    let(:user) { FactoryGirl.create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'alle Benutzer') }
    it { should have_selector('h1', text: 'alle Benutzer') }

    it "sollte jeden Benutzer listen" do
      User.limit 30  do |user|
        page.should have_selector('li', text: user.name)
      end
    end

    describe "als administrativer Benutzer" do

      let(:admin) { FactoryGirl.create(:admin) }

      before do
        sign_in admin
        visit users_path
      end

      it { should have_link('löschen') }
      it {should_not have_link('löschen', href: user_path(admin.login))}

      it "sollte einen Benutzer löschen können" do
        expect { click_link('löschen') }.to change(User, :count).by(-1)
      end
    end

    describe "als angemeldeter Benutzer" do

      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        visit users_path
      end

      it { should have_link('Abmelden') }

       describe "sollte nach dem Abmelden eine Anmelden Link haben" do
         before { click_link('Abmelden') }
         it { should have_link('Anmelden') }
       end
    end
  end

  describe "User registrierungs Seite" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'User Registrierung') }
    it { should have_selector('title', text: full_title('User Registrierungs Seite')) }
  end

  describe "Profil Seite" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user.login) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: full_title(user.name)) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "User Konto anlegen" }

    describe "mit ungültiger Information" do
      it "sollte keinen user erzeugen" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "mit gültiger Information" do
      before do
        fill_in "Name",          with: "Test User"
        fill_in "Login",         with: "tester"
        fill_in "Email",         with: "test@example.com"
        fill_in "Passwort",      with: "foobar"
        fill_in "Passwort wiederholen",  with: "foobar"
      end

      it "sollte einen User erzeugen" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user.login)
    end

    describe "page" do
      it { should have_selector('h1', text: "Profil editieren") }
      it { should have_selector('title', text: "Benutzer editieren") }
      it { should have_selector('h1', href: 'http://gravatar.com/emails') }
    end

    describe "mit gültiger Information" do
      let(:new_name) { "Neuer Name" }
      let(:new_email) { "neu@email.com" }
      before do
        fill_in "Name",       with: new_name
        fill_in "Email",      with: new_email
        fill_in "Passwort",   with: user.password
        fill_in "Passwort wiederholen", with: user.password
        click_button "Änderungen speichern"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }

    end

    describe "mit ungültiger Information" do
      before { click_button "Änderungen speichern" }

      it { should have_content('Fehler') }
    end
  end
end
