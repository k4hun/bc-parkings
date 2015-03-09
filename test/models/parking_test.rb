require 'test_helper'

class ParkingTest < ActiveSupport::TestCase
  def setup
    @parking = parkings(:expensive_one)
  end

  test 'is invalid without number of places' do
    @parking.places = nil

    assert @parking.invalid?
    assert @parking.errors.has_key?(:places)
  end

  test 'is invalid when hour price is not numeric' do
    @parking.hour_price = "asd"

    assert @parking.invalid?
    assert @parking.errors.has_key?(:hour_price)
  end

  test 'is invalid when day price is not numeric' do
    @parking.day_price = "zxc"

    assert @parking.invalid?
    assert @parking.errors.has_key?(:day_price)
  end

  test 'is invalid for wrong kind of parking' do
    @parking.kind = "asdcxz"

    assert @parking.invalid?
    assert @parking.errors.has_key?(:kind)
  end

  test 'finish rents when destroyed' do
    @parking.destroy
    assert_in_delta DateTime.now.to_i, @parking.place_rents.first.ends_at.to_i, 1
  end
end
