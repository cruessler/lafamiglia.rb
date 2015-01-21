require 'test_helper'

class VillaTest < ActiveSupport::TestCase
  test "should update counter caches" do
    v = villas(:one)
    v.building_queue_items.enqueue LaFamiglia.building(1)
    v.save

    assert_equal 1, v.building_queue_items_count

    v.building_queue_items.dequeue v.building_queue_items.last

    assert_equal 0, v.building_queue_items_count
  end
end
