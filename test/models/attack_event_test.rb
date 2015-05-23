require 'test_helper'

class AttackEventTest < ActiveSupport::TestCase
  setup do
    Dispatcher.logger = Logger.new File::NULL
  end

  def create_and_handle_attack origin, target
    attack = AttackMovement.create(origin: origin,
                                   target: target,
                                   units: origin.units)

    LaFamiglia.clock(LaFamiglia.now + attack.duration)

    event = Dispatcher::AttackEvent.new attack
    event.handle NullDispatcher.new

    target.reload
  end

  test "should begin an occupation when an attack is successful" do
    origin, target = villas(:occupying_villa, :villa_to_be_occupied)

    refute_predicate target, :occupied?

    target.unit_queue_items.enqueue LaFamiglia.units.get_by_id(1), 5

    create_and_handle_attack origin, target

    assert_equal target, Occupation.last.occupied_villa
    assert_equal 0, target.unit_queue_items.count
    assert_predicate target, :occupied?
  end

  test "should replace an existing occupation when an attack is successful" do
    origin, target = villas(:villa_attacking_an_occupied_villa, :occupied_villa)

    old_occupation = target.occupied_by

    create_and_handle_attack origin, target

    assert_not_equal old_occupation, target.occupied_by
  end

  test "should send a report to the relevant players" do
    origin, target, occupied_by = villas(:villa_attacking_an_occupied_villa,
                                         :occupied_villa,
                                         :occupying_villa)

    assert_difference -> { occupied_by.player.unread_reports_count } do
      assert_difference -> { origin.player.unread_reports_count } do
        assert_no_difference -> { target.player.unread_reports_count } do
          create_and_handle_attack origin, target
          occupied_by.reload
        end
      end
    end
  end
end
