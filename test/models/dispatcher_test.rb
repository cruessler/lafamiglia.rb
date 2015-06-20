require 'test_helper'

class DispatcherTest < ActiveSupport::TestCase
  setup do
    setup_for_occupation_test
  end

  test "should not retain stale events in event queue" do
    attack = AttackMovement.create(origin: @origin,
                                   target: @target,
                                   units: @origin.units)
    old_player = @target.player

    event_loop = EventHandler::EventLoop.new

    LaFamiglia.clock attack.arrives_at
    event_loop.process_events_until! attack.arrives_at

    occupation = Occupation.last
    occupation.cancel!

    LaFamiglia.clock occupation.succeeds_at
    event_loop.process_events_until! occupation.succeeds_at

    assert_equal old_player, @target.player
  end
end
