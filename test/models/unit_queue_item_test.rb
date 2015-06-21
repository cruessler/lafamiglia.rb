require 'test_helper'

class UnitQueueItemTest < ActiveSupport::TestCase
  setup do
    @unit_1 = LaFamiglia.units.get_by_id 1
  end

  test "should not start recruiting in an occupied villa" do
    v = villas(:occupied_villa)
    v.processed_until = LaFamiglia.now

    assert_predicate v, :occupied?
    assert_not v.unit_queue_items.enqueue(@unit_1, 5)
  end

  test "should free supply when an item is cancelled" do
    v = villas(:one)
    v.processed_until = LaFamiglia.now

    assert_difference -> { v.used_supply }, @unit_1.supply do
      v.unit_queue_items.enqueue @unit_1, 5

      LaFamiglia.clock LaFamiglia.now + @unit_1.build_time * 1.1

      v.process_until! LaFamiglia.now

      v.unit_queue_items.dequeue v.unit_queue_items.last
    end
  end

  test "should recruit in discrete steps" do
    v = villas(:one)
    v.processed_until = LaFamiglia.now

    start_number = v.unit_number @unit_1
    number_to_recruit = 50

    v.unit_queue_items.enqueue @unit_1, number_to_recruit

    1.upto(number_to_recruit) do |i|
      v.process_until! LaFamiglia.now + (@unit_1.build_time(i) * 0.9)

      assert_equal start_number + number_to_recruit,
                   v.unit_number(@unit_1) + v.unit_queue_items.first.number
    end
  end
end
