class MovementsController < ApplicationController
  before_action :set_movement, only: [ :destroy ]

  # GET /movements
  def index
    @outgoings   = current_player.outgoings
    @occupations = current_player.occupations
  end

  # DELETE /movements/1
  def destroy
    if @movement.cancellable? && @comeback = @movement.cancel!
      notify_dispatcher @comeback.arrives_at
      redirect_to :back, notice: I18n.t('movements.cancelled')
    else
      redirect_to villa_movements_url(current_villa), alert: @movement.errors[:base].join
    end
  end

  private

  def set_movement
    @movement = current_villa.outgoings.find(params[:id])
  end
end
