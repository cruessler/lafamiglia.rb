class BuildingQueueItem < ActiveRecord::Base
  belongs_to :villa, counter_cache: true

  def building
    @building ||= LaFamiglia.building building_id
  end
end
