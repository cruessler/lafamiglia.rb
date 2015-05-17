require 'test_helper'

class ComebackMovementTest < ActiveSupport::TestCase
  setup do
    setup_for_occupation_test
  end

  test "comeback movement created by conquest should have non-zero duration" do
    create_and_handle_occupation @origin, @target

    comeback = ComebackMovement.last

    assert_not_nil comeback.duration
    assert_not_equal 0, comeback.duration
  end
end
