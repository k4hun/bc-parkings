class Person < ActiveRecord::Base
  has_many :cars, foreign_key: 'owner_id'
  has_many :parkings, foreign_key: 'owner_id'
  has_one :account, foreign_key: 'user_id'

  validates :first_name, presence: true

  def full_name
    last_name.blank? ? first_name : "#{first_name} #{last_name}"
  end
end
