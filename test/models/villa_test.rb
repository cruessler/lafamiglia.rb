require 'test_helper'

class VillaTest < ActiveSupport::TestCase
  setup do
    @v = villas(:one)
    @v.processed_until = LaFamiglia.now

    @unit_1 = LaFamiglia.units.get_by_id 1
    @unit_2 = LaFamiglia.units.get_by_id 2
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
    units = @v.units

    @v.unit_queue_items.enqueue @unit_1, 10

    @v.process_until! LaFamiglia.now + @unit_1.build_time(5)
    assert_equal units[@unit_1.key] + 5, @v.unit_number(@unit_1)

    @v.process_until! LaFamiglia.now + @unit_1.build_time(15)
    assert_equal units[@unit_1.key] + 10, @v.unit_number(@unit_1)
  end

  test "should recruit units virtually" do
    units = @v.units

    @v.unit_queue_items.enqueue @unit_1, 10

    @v.process_virtually_until! LaFamiglia.now + @unit_1.build_time(5)
    assert_equal units[@unit_1.key] + 5, @v.unit_number(@unit_1)
  end

  test "should return virtual unit number" do
    assert_difference -> { @v.virtual_unit_number(@unit_1) }, 10 do
      assert_difference -> { @v.virtual_unit_number(@unit_2) } do
        @v.unit_queue_items.enqueue @unit_1, 2
        @v.unit_queue_items.enqueue @unit_2, 1
        @v.unit_queue_items.enqueue @unit_1, 8

        LaFamiglia.clock(LaFamiglia.now + @unit_1.build_time(10) + @unit_2.build_time(1))
      end
    end
  end

  test "should find an empty space for a new villa" do
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

  test "should respect game speed" do
    building = LaFamiglia.buildings.get_by_id 1
    build_time = building.build_time 1

    LaFamiglia.config.game_speed *= 2

    assert_not_equal build_time, building.build_time(1)
  end

  test "should cancel recruiting" do
    1.upto 3 do
      @v.unit_queue_items.enqueue @unit_1, 5
    end

    assert_not_equal 0, @v.unit_queue_items.count
    assert_not_equal 0, @v.unit_queue_items_count

    @v.unit_queue_items.delete_all

    assert_equal 0, @v.unit_queue_items_count
    assert_equal 0, @v.unit_queue_items.count
  end

  test "should have positive max_points" do
    assert Villa.max_points > 0
  end

  test "should have correct duration_of_occupation" do
    assert_operator @v.duration_of_occupation, :>, LaFamiglia.config.duration_of_occupation_base
    assert_operator @v.duration_of_occupation, :<, 2 * LaFamiglia.config.duration_of_occupation_base
  end
end
