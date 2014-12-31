module QueueExtension
  def villa
    proxy_association.owner
  end

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
      time_diff = queue_item.completion_time - LaFamiglia.now
    else
      time_diff = queue_item.build_time
    end

    return transaction do
      destroy(queue_item)

      each do |i|
        if i.completion_time > queue_item.completion_time
          i.completion_time = i.completion_time - time_diff
          i.save
        end
      end

      villa.add_resources!(refunds queue_item, time_diff)
      villa.save

      true
    end
  end
end
