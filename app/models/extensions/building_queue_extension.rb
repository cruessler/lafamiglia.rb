module BuildingQueueExtension
  def finished_until timestamp
    select do |i|
      i.completion_time <= timestamp
    end
  end

  def completion_time
    if last
      last.completion_time
    else
      LaFamiglia.now
    end
  end

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
    count do |i|
      i.id == building.id
    end
  end

  def enqueue building
    villa = proxy_association.owner
    level = villa.virtual_level building
    costs = building.costs level

    if level < building.maxlevel
      if villa.has_resources? costs
        build_time = building.build_time(level)

        new_item = BuildingQueueItem.new(villa_id: villa.id,
                                        building_id: building.id,
                                        build_time: build_time,
                                        completion_time: completion_time + build_time)
        villa.subtract_resources! building.costs(level)

        transaction do
          new_item.save
          villa.save
        end

        return true
      else
        villa.errors[:base] << I18n.t('errors.buildings.not_enough_resources')

        return false
      end
    else
      villa.errors[:base] << I18n.t('errors.buildings.already_at_maxlevel')

      return false
    end
  end

  def dequeue queue_item
    villa = proxy_association.owner

    if last_of_its_kind? queue_item
      if queue_item == first
        time_diff = queue_item.completion_time - LaFamiglia.now
      else
        time_diff = queue_item.build_time
      end

      building = LaFamiglia.building(queue_item.building_id)

      refund_ratio = time_diff.to_f / queue_item.build_time
      level = villa.virtual_level(building) - 1
      refunds = building.costs level

      refunds.each_pair do |k, v|
        refunds[k] = v * refund_ratio
      end

      transaction do
        destroy(queue_item)

        each do |i|
          if i.completion_time > queue_item.completion_time
            i.completion_time = i.completion_time - time_diff
            i.save
          end
        end

        villa.add_resources!(refunds)
        villa.save
      end

      return true
    else
      villa.errors[:base] << I18n.t('errors.buildings.not_the_last_one')

      return false
    end
  end
end
