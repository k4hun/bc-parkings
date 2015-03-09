require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = people(:janina)
  end

  test 'is invalid without city' do
    @person.first_name = nil

    assert @person.invalid?
    assert @person.errors.has_key?(:first_name)
  end

  test 'returns full name of current user' do
    assert_equal 'Janina Nowak', @person.full_name
  end

  test 'returns first name of current user if theres no last name' do
    @person.last_name = nil
    assert_equal 'Janina', @person.full_name
  end
end
