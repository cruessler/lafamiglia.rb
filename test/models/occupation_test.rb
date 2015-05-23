require 'test_helper'

class OccupationTest < ActiveSupport::TestCase
  setup do
    @v1 = villas :one
    @v2 = villas :two
  end

  test "a villa should not be not occupied by more than one occupation" do
    refute_predicate @v1, :occupied?

    occupation_1 = Occupation.create(succeeds_at: LaFamiglia.now + 1.hour,
                                     unit_1: 1,
                                     origin: @v2,
                                     target: @v1)
    assert_not_nil occupation_1
    assert_predicate @v1, :occupied?

    assert_raises ActiveRecord::RecordNotUnique do
      occupation_2 = Occupation.create(succeeds_at: LaFamiglia.now + 1.hour,
                                       unit_1: 1,
                                       origin: @v2,
                                       target: @v1)
    end

    occupation_1.destroy

    refute_predicate @v1, :occupied?
  end
end
