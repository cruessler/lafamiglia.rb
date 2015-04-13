require 'test_helper'

class VillaTest < ActiveSupport::TestCase
  setup do
    @v = villas(:one)
    @v.processed_until = LaFamiglia.now
  end

  test "should update counter caches" do
    @v.building_queue_items.enqueue LaFamiglia.buildings.get_by_id 1
    @v.save

    assert_equal 1, @v.building_queue_items_count

    @v.building_queue_items.dequeue @v.building_queue_items.last

    assert_equal 0, @v.building_queue_items_count
  end

  test "should respect storage capacity" do
    @v.process_until! LaFamiglia.now + 1.year

    [ :resource_1, :resource_2, :resource_3 ].each do |r|
      assert_equal @v.storage_capacity, @v.send(r)
    end
  end

  test "should return resources on cancel" do
    old_resources = @v.resources
    @v.building_queue_items.enqueue LaFamiglia.buildings.get_by_id 1
    @v.building_queue_items.dequeue @v.building_queue_items.last

    @v.resources.each_pair do |r, v|
      assert_in_delta old_resources[r], v, 0.00001
    end
  end

  test "should update processed_until" do
    @v.process_until! LaFamiglia.now + 1.minute

    assert_equal LaFamiglia.now + 1.minute, @v.processed_until
  end

  test "should return virtual building level" do
    b = LaFamiglia.buildings.get_by_id 1
    old_level = @v.level b

    2.times do
      @v.building_queue_items.enqueue b
    end

    assert_equal old_level + 2, @v.virtual_building_level(b)
  end

  test "should recruit units" do
    u = LaFamiglia.units.get_by_id 1
    units = @v.units

    @v.unit_queue_items.enqueue u, 10

    @v.process_until! LaFamiglia.now + u.build_time(5)
    assert_equal units[u.key] + 5, @v.unit_number(u)

    @v.process_until! LaFamiglia.now + u.build_time(15)
    assert_equal units[u.key] + 10, @v.unit_number(u)
  end

  test "should recruit units virtually" do
    u = LaFamiglia.units.get_by_id 1
    units = @v.units

    @v.unit_queue_items.enqueue u, 10

    @v.process_virtually_until! LaFamiglia.now + u.build_time(5)
    assert_equal units[u.key] + 5, @v.unit_number(u)
  end

  test "should find an empty space for a new ville" do
    assert_not_nil Villa.empty_coordinates
  end

  test "should create new villas" do
    p = players :one

    villas_count = p.villas.count

    1.upto 5 do
      assert Villa.create_for(p).persisted?
    end

    assert_equal villas_count + 5, p.villas.count
  end
end
