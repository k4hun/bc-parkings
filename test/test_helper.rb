ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class CapybaraTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    Capybara.reset_sessions!
  end

  def log_in
    fill_in('Email', with: 'mail@mail.com')
    fill_in('Password', with: '1234')
    click_button('Log in')
  end
end

