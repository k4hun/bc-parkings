require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  def setup
    @address = addresses(:poznan)
  end

  test 'is invalid without city' do
    @address.city = nil

    assert @address.invalid?
    assert @address.errors.has_key?(:city)
  end

  test 'is invalid without street' do
    @address.street = nil

    assert @address.invalid?
    assert @address.errors.has_key?(:street)
  end

  test 'is invalid with wrong zip code format' do
    @address.zip_code = 123

    assert @address.invalid?
    assert @address.errors.has_key?(:zip_code)
  end
end
