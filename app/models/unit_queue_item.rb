class UnitQueueItem < ActiveRecord::Base
  belongs_to :villa, counter_cache: true

  def unit
    @unit ||= LaFamiglia.unit unit_id
  end

  def building
    unit.building
  end

  def build_time
    unit.build_time number
  end

  def recruit_units_between! timestamp_begin, timestamp_end
    start_time = completion_time - build_time
    start_number = ((timestamp_begin - start_time) / unit.build_time).to_i
    end_number = ((timestamp_end - start_time) / unit.build_time).to_i

    number_recruited = end_number - start_number
    self.number = self.number - number_recruited

    { unit.key => number_recruited }
  end
end
