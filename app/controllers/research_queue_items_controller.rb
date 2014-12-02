class ResearchQueueItemsController < ApplicationController
  before_action :set_villa
  before_action :set_research_queue_item, only: [ :destroy ]

  # POST /research_queue_items
  def create
    research = LaFamiglia.research(params[:research_id].to_i)

    if research
      if current_villa.research_queue_items.enqueue research
        redirect_to current_villa
      else
        redirect_to current_villa, alert: current_villa.errors[:base].join
      end
    end
  end

  # DELETE /research_queue_items/1
  def destroy
    if current_villa.research_queue_items.dequeue @research_queue_item
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

  def set_research_queue_item
    @research_queue_item = current_villa.research_queue_items.find(params[:id])
  end
end
