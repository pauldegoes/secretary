class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :user_logins, dependent: :destroy
  has_one_attached :photo

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.username = auth.info.nickname || auth.info.email.split('@').first
      user.first_name = auth.info.first_name || auth.info.name&.split&.first
      user.last_name = auth.info.last_name || auth.info.name&.split&.last
    end
  end
end
