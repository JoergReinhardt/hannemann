# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  login           :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  password        :string(255)
#

require 'spec_helper'

describe User do
  before { @user = User.new(
    name: "Test User",
    email: "test@test.com",
    login: "testuser",
    password: "foobar",
    password_confirmation: "foobar",
  )}

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:login) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:blogposts) }

  it { should be_valid }
  it { should_not be_admin }

  describe "blogpost Assoziation" do
    before { @user.save }
    let!(:older_blogpost) do
      FactoryGirl.create(:blogpost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_blogpost) do
      FactoryGirl.create(:blogpost, user: @user, created_at: 1.hour.ago)
    end

    it "sollte die blogposts in der richtigen Reihenfolge ausgeben" do
      @user.blogposts.should == [newer_blogpost, older_blogpost]
    end

    it "sollte zum Benutzer gehörende blogposts löschen" do
      blogposts = @user.blogposts
      @user.destroy
      blogposts.each do |blogposts|
        Blogpost.find_by_id(blogpost.id).should be_nil
      end
    end
  end

  describe "Mit gesetztem Admin Attribut" do
    before { @user.toggle!(:admin) }

    it { should be_admin }
  end

  describe "Wenn kein name gesetzt" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "Wenn kein login gesetzt" do
    before { @user.login = " " }
    it { should_not be_valid }
  end

  describe "Wenn keine mail gesetzt" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "Wenn keine passwort gesetzt" do
    before { @user.password = " " }
    it { should_not be_valid }
  end

  describe "Wenn keine password_confirmation gesetzt" do
    before { @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "Wenn keine password_confirmation gesetzt" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "Wenn passwort und confirmation nicht uebereinstimmen" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "Wenn der name zu lang" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "Wenn das login zu lang" do
    before { @user.login = "a" * 21 }
    it { should_not be_valid }
  end

  describe "Wenn das login zu kurz" do
    before { @user.login = "aaa" }
    it { should_not be_valid }
  end

  describe "Wenn das password zu kurz" do
    before { @user.password = "a" * 5 }
    it { should_not be_valid }
  end

  describe "Wenn das Format der email Adresse zulässig ist" do
    it "sollte zulässig sein" do
      adresses = %w[user@foo.COM A_US_ER@f.b.org frst.lst@foo.jp a-b@baz.biz]
      adresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "Wenn das Format der email Adresse unzulässig ist" do
    it "sollte unzulaessig sein" do
      adresses = %w[user@foo,COM user_at_foo.com A_US_ER@f.b.org@frst.lst@foo.jp a+b@b+z.biz]
      adresses.each do |valid_address|
        @user.email = valid_address
        @user.should_not be_valid
      end
    end
  end

  describe "Wenn die email Adresse schon vergeben ist" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "Wenn die email Adresse schon in Grossbuchstaben vergeben ist" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "Wenn das login schon vergeben ist" do
    before do
      user_with_same_login = @user.dup
      user_with_same_login.save
    end
    it { should_not be_valid }
  end

  describe "Rückgabewert des Authentifikations Prozesses" do
    before { @user.save }
    let(:found_user) { User.find_by_login(@user.login) }

    describe "mit gültigem Passwort" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "mit ungültigem Passwort" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

end
