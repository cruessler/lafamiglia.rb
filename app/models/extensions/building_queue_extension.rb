module BuildingQueueExtension
  def last_of_its_kind? queue_item
    building = LaFamiglia.building(queue_item.building_id)

    reverse.each do |i|
      break if i == queue_item

      if i.building_id == building.id
        return false
      end
    end

    return true
  end

  def enqueued_count building
    # count does not work here as it always hits the database
    # and ignores the block.
    # Since this method is only called when the items have
    # already been loaded another database query is not necessary.
    select do |i|
      i.building_id == building.id
    end.length
  end

  def refunds queue_item, time_diff
    building = LaFamiglia.building(queue_item.building_id)

    refund_ratio = time_diff.to_f / queue_item.build_time
    previous_level = villa.virtual_building_level(building) - 1
    refunds = building.costs previous_level

    refunds.each_pair do |k, v|
      refunds[k] = v * refund_ratio
    end

    refunds
  end

  def virtual_level building
    villa.virtual_building_level building
  end

  def build_item building, level
    build_time = building.build_time(level)
    proxy_association.build(building_id: building.id,
                            build_time: build_time,
                            completed_at: completed_at + build_time)
  end

  def error_message key
    I18n.t("errors.buildings.#{key}")
  end
end
