class Parking < ActiveRecord::Base
  before_destroy :finish_rents
  belongs_to :address
  belongs_to :owner, class_name: "Person"
  has_many :place_rents
  accepts_nested_attributes_for :address

  validates :places, presence: true
  KINDS = ['outdoor', 'indoor', 'private', 'street']
  validates :kind, inclusion: { in: KINDS }
  validates :hour_price, :day_price, numericality: true

  def finish_rents
    self.place_rents.active.each(&:finish)
  end

  scope :is_public, -> { where.not(kind: 'private')}
  scope :is_private, -> { where(kind: 'private') }
  scope :day_price_range, -> (min_day_price, max_day_price) { where('day_price BETWEEN ? AND ?', min_day_price, max_day_price) }
  scope :hour_price_range, -> (min_hour_price, max_hour_price) { where('hour_price BETWEEN ? AND ?', min_hour_price, max_hour_price) }
  scope :in_city, -> (city) { joins(:address).merge(Address.in_city(city)) }

  self.per_page = 2

  def self.search(options={})
    parkings = Parking.all
    parkings = parkings.is_public if options[:is_public].present?
    parkings = parkings.is_private if options[:is_private].present?
    parkings = parkings.day_price_range(options[:min_day_price], options[:max_day_price]) if options[:min_day_price].present? && options[:max_day_price].present?
    parkings = parkings.hour_price_range(options[:min_hour_price], options[:maxh
      ]) if options[:min_hour_price].present? && options[:max_hour_price].present?
    parkings = parkings.in_city(options[:city]) if options[:city].present?
    parkings
  end
end
