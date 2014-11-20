class VillasController < ApplicationController
  power :villas

  skip_before_action :check_for_villa!
  before_action :set_villa, only: [ :show ]
  before_action :check_for_villa!

  # GET /villa/1
  def show
  end

  # GET /villas
  def index
    @villas = current_power.villas
  end

  private

  def set_villa
    @villa = current_power.villas.find(params[:id])

    @current_villa = @villa
    @current_villa.process_until! LaFamiglia.now
    session[:current_villa] = @villa.id
  end
end
