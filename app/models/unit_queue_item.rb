class UnitQueueItem < ActiveRecord::Base
  belongs_to :villa, counter_cache: true

  def unit
    @unit ||= LaFamiglia.units.get_by_id unit_id
  end

  def building
    unit.building
  end

  def start_time
    completed_at - build_time
  end

  def build_time
    unit.build_time number
  end

  def units_recruited_until time
    units_recruited_between start_time, time
  end

  def units_recruited_between time_begin = start_time, time_end
    start_number = ((time_begin - start_time) / unit.build_time).to_i
    end_number = ((time_end - start_time) / unit.build_time).to_i

    end_number - start_number
  end

  def recruit_units_between! time_begin, time_end
    number_recruited = units_recruited_between(time_begin, time_end)
    self.number = self.number - number_recruited

    { unit.key => number_recruited }
  end
end
