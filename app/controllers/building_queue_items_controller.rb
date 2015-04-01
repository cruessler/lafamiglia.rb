class BuildingQueueItemsController < ApplicationController
  before_action :set_villa
  before_action :set_building_queue_item, only: [ :destroy ]

  # POST /building_queue_items
  def create
    building = LaFamiglia.buildings.get_by_id params[:building_id].to_i

    if building
      if @building_queue_item = current_villa.building_queue_items.enqueue(building)
        notify_dispatcher @building_queue_item.completed_at
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

  def set_villa
    @villa = current_player.villas.find(params[:villa_id])

    @current_villa = @villa
    @current_villa.process_until! LaFamiglia.now
    session[:current_villa] = @villa.id
  end

  def set_building_queue_item
    @building_queue_item = current_villa.building_queue_items.find(params[:id])
  end
end
