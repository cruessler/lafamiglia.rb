module UnitQueueExtension
  def villa
    proxy_association.owner
  end

  def finished_until time
    select do |i|
      i.completed_at <= time
    end
  end

  def completed_at
    last.completed_at if last
  end

  def enqueued_count_until unit, time
    inject(0) do |number, i|
      if i.completed_at <= time
        if i.unit_id == unit.id
          number += i.number
        end
      else
        if i.unit_id == unit.id
          number += i.units_recruited_until(time)
        end

        return number
      end

      number
    end
  end

  def enqueue unit, number
    costs = unit.costs number
    supply = unit.supply number

    if villa.occupied?
      villa.errors[:base] << I18n.t('errors.units.villa_is_occupied')

      return false
    end

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
                                      completed_at: (completed_at || LaFamiglia.now) + unit.build_time(number))
    villa.subtract_resources! costs
    villa.used_supply += supply

    transaction do
      new_item.save
      villa.save

      true
    end
  end

  def dequeue queue_item
    if queue_item == first
      time_diff = queue_item.completed_at - LaFamiglia.now
    else
      time_diff = queue_item.build_time
    end

    unit        = queue_item.unit
    number_left = queue_item.units_recruited_between LaFamiglia.now, completed_at

    transaction do
      destroy(queue_item)

      each do |i|
        if i.completed_at > queue_item.completed_at
          i.completed_at -= time_diff
          i.save
        end
      end

      # Don’t refund resources for the first unit that has already started
      # being recruited.
      villa.add_resources!(unit.costs number_left - 1)
      villa.used_supply -= unit.supply(number_left)
      villa.save

      true
    end
  end

  def cancel_all
    transaction do
      each do |i|
        villa.used_supply -= i.unit.supply(i.number)
      end

      delete_all
      villa.save
    end
  end
end
