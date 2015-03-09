require 'test_helper'
class PlaceRentsTest < CapybaraTest
  test "rent a place" do
    visit parkings_path
    first(:link, 'Rent a place').click
    fill_in('Start date', with: '2015-03-17T15:05')
    fill_in('End date', with: '2015-03-17T15:06')
    select('Model1', from: 'Select car')
    click_on('Send')

    assert_equal(current_path, parkings_path)
    assert page.has_content?('Place rented!')
  end

  test 'display place rent price' do
    visit place_rents_path
    assert all('#rents tr > td:nth-child(3)').last.text != ""
  end
end
