require 'test_helper'

class ConquerEventTest < ActiveSupport::TestCase
  setup do
    @origin = villas(:occupying_villa)
    @target = villas(:occupied_villa)

    @origin.processed_until = LaFamiglia.now
    @target.processed_until = LaFamiglia.now

    Dispatcher.logger = Logger.new File::NULL
  end

  test "should change owner of a conquered villa" do
    occupation = Occupation.create(succeeds_at: LaFamiglia.now + LaFamiglia.config.duration_of_occupation,
                                   occupied_villa: @target,
                                   occupying_villa: @origin,
                                   unit_2: 1)

    old_number_of_villas = @origin.player.villas.count

    assert_not_equal @origin.player, @target.player

    LaFamiglia.clock(LaFamiglia.now + LaFamiglia.config.duration_of_occupation)

    event = Dispatcher::ConquerEvent.new occupation
    event.handle NullDispatcher.new

    assert_equal @origin.player, @target.player
    assert_equal old_number_of_villas + 1, @origin.player.villas.count

    comeback = ComebackMovement.last

    assert_not_nil comeback.duration
    assert_not_equal 0, comeback.duration
  end
end
