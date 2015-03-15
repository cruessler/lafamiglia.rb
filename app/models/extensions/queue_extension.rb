module QueueExtension
  def villa
    proxy_association.owner
  end

  def finished_until time
    select do |i|
      i.completed_at <= time
    end
  end

  def completed_at
    if last
      last.completed_at
    else
      LaFamiglia.now
    end
  end

  def enqueue object
    level = virtual_level object
    costs = object.costs level

    unless object.requirements_met? villa
      villa.errors[:base] << error_message('requirements_not_met')

      return false
    end

    unless level < object.maxlevel
      villa.errors[:base] << error_message('already_at_maxlevel')

      return false
    end

    unless villa.has_resources? costs
      villa.errors[:base] << error_message('not_enough_resources')

      return false
    end

    new_item = build_item object, level
    villa.subtract_resources! costs

    return transaction do
      new_item.save
      villa.save

      new_item
    end
  end

  def dequeue queue_item
    unless last_of_its_kind? queue_item
      villa.errors[:base] << error_message('not_the_last_one')

      return false
    end

    if queue_item == first
      time_diff = queue_item.completed_at - LaFamiglia.now
    else
      time_diff = queue_item.build_time
    end

    return transaction do
      destroy(queue_item)

      each do |i|
        if i.completed_at > queue_item.completed_at
          i.completed_at = i.completed_at - time_diff
          i.save
        end
      end

      villa.add_resources!(refunds queue_item, time_diff)
      villa.save

      true
    end
  end
end
