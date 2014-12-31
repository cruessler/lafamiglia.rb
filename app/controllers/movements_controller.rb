class MovementsController < ApplicationController
  before_action :set_villa, only: [ :index, :create ]
  before_action :set_movement, only: [ :destroy ]

  # GET /movements
  def index
  end

  # POST /movements
  def create
    @movement = AttackMovement.create_with(origin: current_villa).new(movement_params)

    if @movement.save
      notify_dispatcher @movement.arrival
      redirect_to :back, notice: I18n.t('movements.created')
    else
      render action: 'new'
    end
  end

  # DELETE /movements
  def destroy
    if @comeback = @movement.cancel!
      notify_dispatcher @comeback.arrival
      redirect_to :back, notice: I18n.t('movements.cancelled')
    else
      redirect_to villa_movements_url(current_villa), alert: @movement.errors[:base].join
    end
  end

  private

  def set_villa
    @villa = current_player.villas.find(params[:villa_id])

    @current_villa = @villa
    @current_villa.process_until! LaFamiglia.now
    session[:current_villa] = @villa.id
  end

  def set_movement
    @movement = current_villa.outgoings.find(params[:id])
  end

  def movement_params
    params.require(:movement).permit(:target_id, :unit_1)
  end
end
