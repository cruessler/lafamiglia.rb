require 'test_helper'

class ConquerEventTest < ActiveSupport::TestCase
  setup do
    setup_for_occupation_test
  end

  test "should change owner of a conquered villa" do
    old_number_of_villas = @origin.player.villas.count

    assert_not_equal @origin.player, @target.player

    create_and_handle_occupation @origin, @target

    assert_equal @origin.player, @target.player
    assert_equal old_number_of_villas + 1, @origin.player.villas.count
  end
end
