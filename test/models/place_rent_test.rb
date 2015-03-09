require 'test_helper'

class PlaceRentTest < ActiveSupport::TestCase
  def setup
    @place = place_rents(:first_place)
  end

  test 'is invalid without start time' do
    @place.starts_at = nil

    assert @place.invalid?
    assert @place.errors.has_key?(:starts_at)
  end

  test 'is invalid without end time' do
    @place.ends_at = nil

    assert @place.invalid?
    assert @place.errors.has_key?(:ends_at)
  end

  test 'is invalid without parking' do
    @place.parking = nil

    assert @place.invalid?
    assert @place.errors.has_key?(:parking)
  end

  test 'is invalid without car' do
    @place.car = nil

    assert @place.invalid?
    assert @place.errors.has_key?(:car)
  end

  test 'properly calculates price when the end date is before start date' do
    new_place = PlaceRent.create(starts_at: place_rents(:first_place).ends_at + 5.days,
                             ends_at: place_rents(:first_place).ends_at,
                             car: cars(:opel),
                             parking: parkings(:cheap_one))
    assert_equal 0, new_place.calculate_price.to_f
  end

  test 'properly calculates price when the rent spans over multiple days' do
    new_place = PlaceRent.create(starts_at: place_rents(:first_place).starts_at,
                             ends_at: place_rents(:first_place).starts_at + 5.days,
                             car: cars(:opel),
                             parking: parkings(:cheap_one))
    assert_equal 101, new_place.price.to_f
  end

  test 'properly calculates price when the rent spans over some minutes but less than an hour' do
    new_place = PlaceRent.create(starts_at: place_rents(:first_place).starts_at,
                             ends_at: place_rents(:first_place).starts_at + 30.minutes,
                             car: cars(:opel),
                             parking: parkings(:cheap_one))
    assert_equal 5.5, new_place.price.to_f
  end

  test 'place rent saved with proper price' do
    new_place = PlaceRent.create(starts_at: place_rents(:first_place).starts_at,
                                 ends_at: place_rents(:first_place).ends_at,
                                 car: cars(:opel),
                                 parking: parkings(:cheap_one))
    assert_equal 101, new_place.price.to_f.round(2)
  end

  test "rent price doesn't change when parking prices are modified" do
    old_price = @place.price
    @place.parking.update_attributes(day_price: 123.4, hour_price: 432.1)
    assert_equal old_price, @place.price
  end
end
