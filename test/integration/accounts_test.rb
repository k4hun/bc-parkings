require 'test_helper'
class AccountsTest < CapybaraTest
  test 'user registers' do
    visit register_path
    fill_in('Email', with: 'test@mail.com')
    fill_in('Password', with: 'testpass')
    fill_in('Password confirmation', with: 'testpass')
    fill_in('First name', with: 'Foo')
    fill_in('Last name', with: 'Bar')
    click_on('Create')

    assert_equal 'test@mail.com', Account.last.email
    assert_equal 'Foo', Account.last.user.first_name

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal 'Welcome to Bookparking.', ActionMailer::Base.deliveries.first.subject
    assert_equal ['test@mail.com'], ActionMailer::Base.deliveries.first.to
  end
end
