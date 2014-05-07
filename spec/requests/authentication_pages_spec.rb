# encoding: utf-8
require 'spec_helper'

describe "Authentication" do 
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Anmelden') }
    it { should have_selector('title', text: 'Anmelden') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "mit ungültiger Information" do
      before { click_button "Anmelden" }

      it { should have_selector('title', text: 'Anmelden') }
      it { should have_selector('div.alert.alert-error', text: 'Ungültige') }
    end

    describe "mit gültiger Information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title',    text: user.name) }

      it { should have_link('alle Benutzer',  href: users_path) }
      it { should have_link('Profil',  href: user_path(user)) }
      it { should have_link('Abmelden', href: signout_path) }
      it { should have_link('Einstellungen', href: edit_user_path(user)) }
      it { should have_link('Abmelden', href: signout_path) }

      it { should_not have_link('Anmelden', href: signin_path) }
    end
  end

  describe "authorization" do

    describe "als nicht administrativer Benutzer" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "Einen lösch request senden an users#destroy" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    describe "für nicht eingelogte Benutzer" do
      let(:user) { FactoryGirl.create(:user) }

      describe "Versuch eine geschützte Seite aufzurufen" do
        before do
          visit edit_user_path(user)
          fill_in "Login", with: user.login
          fill_in "Passwort", with: user.password
          click_button "Anmelden"
        end

        describe "nach dem Anmelden" do

          it "sollte die vor dem Anmelden angeforderte Seite anzeigen" do
            page.should have_selector('title', text: 'Benutzer editieren')
          end
        end
      end

      describe "im User Controller" do

        describe "Die User Edit Seite besuchen" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Anmelden') }
        end

        describe "an die User Action absenden" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        
        describe "den User Index aufrufen" do
          before { visit users_path }
          it { should have_selector('title', text: 'Anmelden') }
        end
      end
    end

    describe "als falscher Benutzer" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, login: "wrong_user", email: "andere@email.com") }
      before { sign_in user }

      describe "Die User Einstellungs Seite besuchen" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Benutzer editieren')) }
      end

      describe "Einen PUT Request an die User#Update Action schicken" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
