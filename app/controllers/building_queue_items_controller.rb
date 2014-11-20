class BuildingQueueItemsController < ApplicationController
  before_filter :set_building_queue_item, only: [ :destroy ]

  # POST /building_queue_items
  def create
    building = LaFamiglia.building(params[:building_id].to_i)

    if building
      if current_villa.building_queue_items.enqueue building
        redirect_to current_villa
      else
        redirect_to current_villa, alert: current_villa.errors[:base].join
      end
    end
  end

  # DELETE /building_queue_items/1
  def destroy
    if current_villa.building_queue_items.dequeue @building_queue_item
      redirect_to current_villa
    else
      redirect_to current_villa, alert: current_villa.errors[:base].join
    end
  end

  private

  def set_building_queue_item
    @building_queue_item = current_villa.building_queue_items.find(params[:id])
  end
end
