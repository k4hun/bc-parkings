require 'test_helper'
class ParkingsTest < CapybaraTest

  def fill_form
    fill_in('Places', with: 5)
    select('indoor', from: 'Kind')
    fill_in('Hour price', with: 12.5)
    fill_in('Day price', with: 8.9)
    fill_in('City', with: 'test_city')
    fill_in('Street', with: 'test street')
    fill_in('Zip code', with: '22-333')
    click_on('Send')
  end

  test "user opens parkings index" do
    visit parkings_path
    assert has_content? 'Parkings'
  end

  test 'user opens parking details' do
    visit parkings_path
    first(:link, 'Show').click
    assert has_content?
  end

  test 'user adds a new parking' do
    visit parkings_path
    click_link('New parking')
    fill_form

    assert_equal(current_path, parkings_path)
    assert page.has_content?('Parking added!')
  end

  test 'user edits a parking' do
    visit parkings_path
    first(:link, 'Edit').click
    fill_form

    assert page.has_content?('Parking updated!')
  end

  test 'user removes a parking' do
    visit parkings_path
    first(:link, 'Remove').click

    assert_equal(current_path, parkings_path)
    assert page.has_content?('Parking destroyed!')
  end

  test 'search form keeps its values' do
    visit parkings_path
    check(:is_public)
    check(:is_private)
    fill_in(:min_day_price, with: '12')
    fill_in(:max_day_price, with: '43')
    fill_in(:min_hour_price, with: '1')
    fill_in(:max_hour_price, with: '4')
    fill_in(:city, with: 'Poz')
    click_on('Search')

    assert_equal(current_path, parkings_path)
    assert_equal 'on', find('#is_public').value
    assert_equal 'on', find('#is_private').value
    assert_equal '12', find('#min_day_price').value
    assert_equal '43', find('#max_day_price').value
    assert_equal '1', find('#min_hour_price').value
    assert_equal '4', find('#max_hour_price').value
    assert_equal 'Poz', find('#city').value
  end
end
