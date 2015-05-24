class Villas::MovementsController < ApplicationController
  before_action :set_villa, only: [ :index, :create ]

  # GET /movements
  def index
    @outgoings   = current_villa.outgoings
    @occupations = current_villa.occupations
  end

  # POST /movements
  def create
    @movement = AttackMovement.create_with(origin: current_villa).new(movement_params)

    if @movement.save
      notify_dispatcher @movement.arrives_at
      redirect_to :back, notice: I18n.t('movements.created')
    else
      render action: 'new'
    end
  end

  private

  def set_villa
    @villa = current_player.villas.find(params[:villa_id])

    @current_villa = @villa
    @current_villa.process_until! LaFamiglia.now
    session[:current_villa] = @villa.id
  end

  def movement_params
    params.require(:movement).permit(:target_id, :unit_1, :unit_2)
  end
end
