class UserLogin < ApplicationRecord
  belongs_to :user

  validates :ip_address, presence: true
  validates :signed_in_at, presence: true

  scope :recent, -> { order(signed_in_at: :desc) }
end
