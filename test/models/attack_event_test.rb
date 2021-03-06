require 'test_helper'

class AttackEventTest < ActiveSupport::TestCase
  def assert_no_units villa
    LaFamiglia.units.each do |u|
      assert_equal 0, villa.unit_number(u)
    end
  end

  test "should begin an occupation when an attack is successful" do
    origin, target = villas(:occupying_villa,
                            :villa_to_be_occupied)

    refute_predicate target, :occupied?

    create_and_handle_attack origin, target

    assert_equal target, Occupation.last.target
    assert_predicate target, :occupied?
  end

  test "should cancel all recruiting orders when an occupation begins" do
    origin, target = villas(:occupying_villa,
                            :villa_to_be_occupied)

    target.unit_queue_items.enqueue LaFamiglia.units.get_by_id(1), 10
    target.unit_queue_items.enqueue LaFamiglia.units.get_by_id(1), 10

    create_and_handle_attack origin, target

    assert_predicate target, :occupied?

    # If there were any troop movements originating from target used_supply
    # would be greater than 0. Because it is known there are none we can test
    # for used_supply being 0.
    assert_equal 0, target.used_supply
    assert_equal 0, target.unit_queue_items.count
    assert_no_units target
  end

  test "should replace an existing occupation when an attack is successful" do
    origin, target = villas(:villa_attacking_an_occupied_villa, :occupied_villa)

    old_occupation = target.occupation

    create_and_handle_attack origin, target

    assert_not_equal old_occupation, target.occupation
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

  test "should cancel an occupation if there is no unit left that can occupy" do
    origin, target = villas(:villa_having_few_units,
                            :occupied_villa)

    target.occupation.send "#{LaFamiglia.config.unit_for_occupation}=", 0
    target.occupation.save

    assert_difference -> { ComebackMovement.count } do
      assert_difference -> { Occupation.count }, -1 do
        create_and_handle_attack origin, target
      end
    end

    assert_nil target.occupation
    assert_operator LaFamiglia.now, :<, ComebackMovement.last.arrives_at
  end

  test "test should destroy all units when an attack is successful" do
    origin, target = villas(:villa_having_lots_of_units,
                            :villa_having_few_units)

    target.unit_queue_items.enqueue LaFamiglia.units.get_by_id(1), 10
    target.unit_queue_items.enqueue LaFamiglia.units.get_by_id(1), 10

    create_and_handle_attack origin, target

    # This assertion implicitly relies on `LaFamiglia.config.unit_speed`. The
    # lower `unit_speed` is, the longer the attack will take. It is thus
    # possible that the attack only arrives when the unit queue has processed
    # all items and is empty.
    assert_operator 0, :<, target.unit_queue_items.count
    assert_no_units target
  end
end
