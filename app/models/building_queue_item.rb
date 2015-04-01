class BuildingQueueItem < ActiveRecord::Base
  belongs_to :villa, counter_cache: true

  def building
    @building ||= LaFamiglia.buildings.get_by_id building_id
  end
end
