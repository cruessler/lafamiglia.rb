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

    Dispatcher.logger = Logger.new File::NULL
  end

  def setup_for_occupation_test
    @origin = villas(:occupying_villa)
    @target = villas(:villa_to_be_occupied)

    @origin.processed_until = LaFamiglia.now
    @target.processed_until = LaFamiglia.now
  end

  def null_event_loop
    @null_event_loop ||= NullEventLoop.new
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

  def create_and_handle_attack origin, target
    attack = AttackMovement.create(origin: origin,
                                   target: target,
                                   units: origin.units)

    LaFamiglia.clock(LaFamiglia.now + attack.duration)

    event = Dispatcher::AttackEvent.new attack
    event.handle null_event_loop

    target.reload
  end

  def create_and_handle_occupation origin, target
    occupation = Occupation.create(origin: origin,
                                   target: target,
                                   LaFamiglia.config.unit_for_occupation => 1)

    LaFamiglia.clock(LaFamiglia.now + target.duration_of_occupation)

    event = Dispatcher::ConquerEvent.new occupation
    event.handle null_event_loop
  end

  class NullEventLoop
    def add_event_to_queue event
    end
  end
end
