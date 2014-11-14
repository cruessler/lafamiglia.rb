class VillasController < ApplicationController
  power :villas

  before_action :set_villa, only: [ :show ]

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

    unless @villa.nil?
      @current_villa = @villa
      session[:current_villa] = @villa.id
    end
  end
end
