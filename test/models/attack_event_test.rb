require 'test_helper'

class AttackEventTest < ActiveSupport::TestCase
  setup do
    @origin = villas(:occupying_villa)
    @target = villas(:occupied_villa)

    @origin.processed_until = LaFamiglia.now
    @target.processed_until = LaFamiglia.now

    Dispatcher.logger = Logger.new File::NULL
  end

  test "should begin an occupation" do
    attack = AttackMovement.create(origin: @origin,
                                   target: @target,
                                   unit_1: @origin.unit_1,
                                   unit_2: @origin.unit_2)

    LaFamiglia.clock(LaFamiglia.now + attack.duration)

    event = Dispatcher::AttackEvent.new attack

    assert_difference 'Occupation.count' do
      event.handle NullDispatcher.new
    end
  end
end
