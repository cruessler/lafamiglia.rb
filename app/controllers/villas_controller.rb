class VillasController < ApplicationController
  power :villas

  skip_before_filter :check_for_villa!
  before_action :set_villa, only: [ :show ]
  before_filter :check_for_villa!

  # GET /villas/1
  def show
    render 'occupied' if current_villa.occupied?
  end

  # GET /villas
  def index
    @villas = current_power.villas.includes(:unit_queue_items)
  end

  private

  def set_villa
    @villa = current_power.villas.find(params[:id])

    @current_villa = @villa
    @current_villa.process_until! LaFamiglia.now
    session[:current_villa] = @villa.id
  end
end
