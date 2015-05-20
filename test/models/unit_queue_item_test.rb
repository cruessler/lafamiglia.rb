require 'test_helper'

class UnitQueueItemTest < ActiveSupport::TestCase
  setup do
    @v = villas(:occupied_villa)
    @v.processed_until = LaFamiglia.now

    @unit_1 = LaFamiglia.units.get_by_id 1
  end

  test "should not start recruiting in an occupied villa" do
    assert_predicate @v, :occupied?
    assert_not @v.unit_queue_items.enqueue(@unit_1, 5)
  end
end
