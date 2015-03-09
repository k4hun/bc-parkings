class PlaceRent < ActiveRecord::Base
  before_create :calculate_price
  before_validation :generate_identifier

  belongs_to :car
  belongs_to :parking

  validates :starts_at, :ends_at, :parking, :car, :identifier, presence: true
  validates :identifier, uniqueness: true

  scope :active, -> { where('ends_at > ?', DateTime.now)}

  def calculate_price
    if starts_at > ends_at
      return self.price = 0
    end
    total_time = (ends_at - starts_at) / 1.day
    days = total_time.floor
    hours = ((total_time - days) * 24).ceil
    self.price = (parking.day_price * days) + (parking.hour_price * hours)
  end

  def finish
    update_attributes(ends_at: DateTime.now)
  end

  def generate_identifier
    begin
      string = SecureRandom.urlsafe_base64
    end while PlaceRent.where(identifier: string).exists?
    self.identifier = string
  end

  def to_param
    "#{identifier}"
  end
end
