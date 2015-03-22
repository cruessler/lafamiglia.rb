require 'test_helper'

class AttackMovementTest < ActiveSupport::TestCase
  setup do
    @origin = villas(:one)
    @target = villas(:two)

    @origin.processed_until = LaFamiglia.now
    @target.processed_until = LaFamiglia.now
  end

  test "way there and way back should have the same duration" do
    @attack = AttackMovement.create(origin: @origin,
                                    target: @target,
                                    unit_1: 1)

    LaFamiglia.clock(LaFamiglia.now + @attack.duration)

    @comeback = @attack.cancel!

    assert_equal (LaFamiglia.now + @attack.duration), @comeback.arrives_at
  end
end
