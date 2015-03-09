require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  test 'autenthicate account' do
    @account = accounts(:first_acc)
    assert @account.authenticate('mail@mail.com', '1234')
  end
end
