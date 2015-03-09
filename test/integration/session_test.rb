require 'test_helper'
class SessionTest < CapybaraTest
  test 'user logs in and "log out" link appears' do
    visit root_path
    click_link('Log in')
    log_in
    assert_equal root_path, current_path
    assert has_content? 'Hello Krzysztof Kowalski'
    assert has_content? 'Log out'
  end

  test 'user name is not displayed before log in' do
    visit root_path
    assert has_no_content? 'Hello'
  end

  test 'user logs out' do
    visit root_path
    click_link('Log in')
    log_in
    click_link('Log out')
    assert has_no_content? 'Hello'
  end

  test 'redirects to previous path after login' do
    visit cars_path
    log_in
    assert_equal cars_path, current_path
  end

  test 'redirects to root path after login when visit log form directly' do
    visit log_in_path
    log_in
    assert_equal root_path, current_path
  end
end
