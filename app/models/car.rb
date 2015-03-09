class Car < ActiveRecord::Base
  belongs_to :owner, class_name: "Person"
  has_many :place_rents
  dragonfly_accessor :image

  extend Dragonfly::Model::Validations
  validates_size_of :image, maximum: 200.kilobytes
  validates_property :ext, of: :image, in: ['jpg', 'png']

  validates :registration_number, :model, :owner, presence: true

  def to_param
    "#{id}-#{model}"
  end
end
