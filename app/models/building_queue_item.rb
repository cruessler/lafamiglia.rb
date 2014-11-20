class BuildingQueueItem < ActiveRecord::Base
  belongs_to :villa

  def building
    @building ||= LaFamiglia.building building_id
  end
end
