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

class User < ActiveRecord::Base
  # password & password_confirmation sind nur Instanz Variablen, keine
  # Datenbank Reihen
  #
  attr_accessible :email, :login, :name, :password, :password_confirmation
  
  def to_param
    login
  end

  # 'automagische' Funktion, die Passworte in md5 hashes verwandelt und dagegen
  # vergleicht
  #
  has_secure_password
  has_many :blogposts, dependent: :destroy

  # vor dem Speichern die email downcasen und das remember_token erzeugen
  #
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  # Validationen:
  # email via regular expression
  #
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true   # uniqueness macht 
  validates :login, presence: true, length: { maximum: 20, minimum: 4 }, uniqueness: true   # Indices notwendig
  validates :name, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  # Diese Funktion sollte ausserhalb des Modells nicht verfuegbar sein, daher
  # private
  #
  private

    # remember_token erzeugen und setzen (self, weil sonst eine Instanz
    # Variable an Stelle des in der Datenbank befindlichen Wertes
    # erzeugt/geaendert wird
    #
    def create_remember_token 
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
