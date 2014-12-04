module UnitQueueExtension
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

  def enqueue unit, number
    villa = proxy_association.owner
    costs = unit.costs number
    supply = unit.supply number

    unless unit.requirements_met? villa
      villa.errors[:base] << I18n.t('errors.units.requirements_not_met')

      return false
    end

    unless villa.has_supply? supply
      villa.errors[:base] << I18n.t('errors.units.not_enough_supply')

      return false
    end

    unless villa.has_resources? costs
      villa.errors[:base] << I18n.t('errors.units.not_enough_resources')

      return false
    end

    new_item = proxy_association.build(unit_id: unit.id,
                                      number: number,
                                      completion_time: completion_time + unit.build_time(number))
    villa.subtract_resources! costs
    villa.used_supply = villa.used_supply + supply

    return transaction do
      new_item.save
      villa.save

      true
    end
  end

  def dequeue queue_item
    villa = proxy_association.owner

    if queue_item == first
      time_diff = queue_item.completion_time - LaFamiglia.now
    else
      time_diff = queue_item.build_time
    end

    unit = queue_item.unit
    # On dequeuing an item, it is freshly loaded from the database
    # and not taken from current_villa.unit_queue_items. Because it
    # has not been touched by current_villa.process_until!
    # queue_item.number is likely to return a wrong number.
    # Thus, the number of units left has to be computed here.
    number_left = ((queue_item.completion_time - LaFamiglia.now) / unit.build_time).to_i

    return transaction do
      destroy(queue_item)

      each do |i|
        if i.completion_time > queue_item.completion_time
          i.completion_time = i.completion_time - time_diff
          i.save
        end
      end

      villa.add_resources!(queue_item.unit.costs number_left)
      villa.used_supply = villa.used_supply - unit.supply(number_left + 1)
      villa.save

      true
    end
  end
end
