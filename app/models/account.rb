class Account < ActiveRecord::Base
  has_secure_password
  belongs_to :user, class_name: 'Person'
  accepts_nested_attributes_for :user

  validates :user, presence: true

  def self.authenticate(email, password)
    account_check = self.where(email: email).first
    account_check.authenticate(password) if account_check
  end
end
