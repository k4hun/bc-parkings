require 'test_helper'

class CarTest < ActiveSupport::TestCase
  def setup
    @car = cars(:toyota)
  end

  test 'is invalid without registration number' do
    @car.registration_number = nil

    assert @car.invalid?
    assert @car.errors.has_key?(:registration_number)
  end

  test 'is invalid without model' do
    @car.model = nil

    assert @car.invalid?
    assert @car.errors.has_key?(:model)
  end

  test 'is invalid without owner' do
    @car.owner = nil

    assert @car.invalid?
    assert @car.errors.has_key?(:owner)
  end
end
