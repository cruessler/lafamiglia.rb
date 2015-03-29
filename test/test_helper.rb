ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  setup do
    LaFamiglia.clock
  end

  module Logout
    def logout
      delete_via_redirect "/players/sign_out"
    end
  end

  def login player, test_module
    open_session do |sess|
      sess.extend Logout
      sess.extend test_module

      p = players(player)
      # Setting the password in the fixture is not possible.
      p.password = 'password'
      p.save

      sess.post_via_redirect "/players/sign_in", player: { email: p.email, password: 'password' }

      assert_equal p, sess.assigns(:current_player)
    end
  end
end
