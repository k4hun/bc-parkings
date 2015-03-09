require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'page title should display controller name' do
    params[:controller] = 'test_controller'
    assert_equal 'Test controller', page_title
  end
end
