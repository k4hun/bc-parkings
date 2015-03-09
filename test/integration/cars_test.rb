require 'test_helper'
class CarsTest < CapybaraTest

  def fill_form
    fill_in('Model', with: 'test model')
    fill_in('Registration number', with: 'TEST123')
    click_on('Send')
  end

  test "user opens cars index" do
    visit cars_path
    assert has_content? 'Cars index'
  end

  test 'user opens car details' do
    visit cars_path
    first(:link, 'Show').click
    assert has_content? 'Show car'
  end

  test 'user adds a new car' do
    visit cars_path
    click_link('New car')
    fill_form

    assert_equal current_path, cars_path
    assert page.has_content?('Car created!')
  end

  test 'user edits a car' do
    visit cars_path
    first(:link, 'Edit').click
    fill_form

    assert page.has_content?('Car updated!')
  end

  test 'user removes a car' do
    visit cars_path
    first(:link, 'Remove').click

    assert_equal current_path, cars_path
    assert page.has_content?('Car destroyed!')
  end
end
