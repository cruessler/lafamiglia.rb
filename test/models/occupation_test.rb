require 'test_helper'

class OccupationTest < ActiveSupport::TestCase
  setup do
    setup_for_occupation_test
  end

  test "a villa should not be not occupied by more than one occupation" do
    refute_predicate @origin, :occupied?

    occupation_1 = Occupation.create(unit_1: 1,
                                     origin: @target,
                                     target: @origin)
    assert_not_nil occupation_1
    assert_predicate @origin, :occupied?

    assert_raises ActiveRecord::RecordNotUnique do
      occupation_2 = Occupation.create(unit_1: 1,
                                       origin: @target,
                                       target: @origin)
    end

    occupation_1.destroy

    refute_predicate @origin, :occupied?
  end

  test "an occupation can be cancelled" do
    attack = AttackMovement.create(origin: @origin,
                                   target: @target,
                                   units: @origin.units)

    LaFamiglia.clock attack.arrives_at

    event = Dispatcher::AttackEvent.new attack
    event.handle null_event_loop

    occupation = Occupation.last

    assert_difference -> { ComebackMovement.count } do
      occupation.cancel!
    end

    @target.reload
    comeback = ComebackMovement.last

    refute_predicate @target, :occupied?
    assert_equal @origin, comeback.origin
    assert_equal @target, comeback.target
  end
end
