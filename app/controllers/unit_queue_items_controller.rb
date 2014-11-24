class UnitQueueItemsController < ApplicationController
  before_filter :set_unit_queue_item, only: [ :destroy ]

  # POST /unit_queue_items
  def create
    unit = LaFamiglia.unit(params[:unit_id].to_i)
    number = [ params[:number].to_i, 0 ].max

    if unit
      if current_villa.unit_queue_items.enqueue unit, number
        redirect_to current_villa
      else
        redirect_to current_villa, alert: current_villa.errors[:base].join
      end
    end
  end

  # DELETE /unit_queue_items/1
  def destroy
    if current_villa.unit_queue_items.dequeue @unit_queue_item
      redirect_to current_villa
    else
      redirect_to current_villa, alert: current_villa.errors[:base].join
    end
  end

  private

  def set_unit_queue_item
    @unit_queue_item = current_villa.unit_queue_items.find(params[:id])
  end
end
