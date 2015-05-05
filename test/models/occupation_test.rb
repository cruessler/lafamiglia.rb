require 'test_helper'

class OccupationTest < ActiveSupport::TestCase
  setup do
    @v1 = villas :one
    @v2 = villas :two
  end

  test "a villa should not be not occupied by more than one occupation" do
    occupation_1 = Occupation.create(succeeds_at: LaFamiglia.now + 1.hour,
                                     unit_1: 1,
                                     occupied_villa: @v1,
                                     occupying_villa: @v2)
    assert_not_nil occupation_1

    assert_raises ActiveRecord::RecordNotUnique do
      occupation_2 = Occupation.create(succeeds_at: LaFamiglia.now + 1.hour,
                                       unit_1: 1,
                                       occupied_villa: @v1,
                                       occupying_villa: @v2)
    end
  end
end
