require 'test_helper'

class OccupationTest < ActiveSupport::TestCase
  setup do
    setup_for_occupation_test
  end

  test "a villa should not be not occupied by more than one occupation" do
    refute_predicate @origin, :occupied?

    occupation_1 = Occupation.create(succeeds_at: LaFamiglia.now + 1.hour,
                                     unit_1: 1,
                                     origin: @target,
                                     target: @origin)
    assert_not_nil occupation_1
    assert_predicate @origin, :occupied?

    assert_raises ActiveRecord::RecordNotUnique do
      occupation_2 = Occupation.create(succeeds_at: LaFamiglia.now + 1.hour,
                                       unit_1: 1,
                                       origin: @target,
                                       target: @origin)
    end

    occupation_1.destroy

    refute_predicate @origin, :occupied?
  end
end
