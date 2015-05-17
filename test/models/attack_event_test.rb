require 'test_helper'

class AttackEventTest < ActiveSupport::TestCase
  setup do
    @origin = villas(:occupying_villa)
    @target = villas(:occupied_villa)

    @origin.processed_until = LaFamiglia.now
    @target.processed_until = LaFamiglia.now

    Dispatcher.logger = Logger.new File::NULL
  end

  test "should begin an occupation when an attack is successful" do
    refute_predicate @target, :occupied?

    @target.unit_queue_items.enqueue LaFamiglia.units.get_by_id(1), 5

    attack = AttackMovement.create(origin: @origin,
                                   target: @target,
                                   units: @origin.units)

    LaFamiglia.clock(LaFamiglia.now + attack.duration)

    event = Dispatcher::AttackEvent.new attack
    event.handle NullDispatcher.new

    @target.reload

    assert_equal @target, Occupation.last.occupied_villa
    assert_equal 0, @target.unit_queue_items.count
    assert_predicate @target, :occupied?
  end
end
