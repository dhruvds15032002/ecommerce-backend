class User < ApplicationRecord
  has_many :orders
  has_one :cart, dependent: :destroy
  has_secure_password

  validates :email, presence: true, uniqueness: true
  # validates :password, presence: true, length: { minimum: 6 }

  def regenerate_token!
    self.token = SecureRandom.hex(10)
    save!
  end

  def invalidate_token!
    self.token = nil
    save!
  end
end
