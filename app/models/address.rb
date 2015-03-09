class Address < ActiveRecord::Base
  has_one :parking

  validates :city, :street, presence: true
  validates :zip_code, format: { with: /\A\d{2}-\d{3}\z/ }

  scope :in_city, -> (city) { where('city = ?', city) }
end
