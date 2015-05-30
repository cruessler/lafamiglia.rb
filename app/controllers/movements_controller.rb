class MovementsController < ApplicationController
  before_action :set_movement, only: [ :destroy ]

  # GET /movements
  def index
    @outgoings   = current_player.outgoings
    @occupations = current_player.occupations
  end

  # DELETE /movements/1
  def destroy
    if @movement.cancellable?
      comeback = @movement.cancel!

      notify_event_handler comeback.arrives_at

      redirect_to :back, notice: I18n.t('movements.cancelled')
    else
      redirect_to :back, alert: I18n.t('movements.cancel_not_possible')
    end
  end

  private

  def set_movement
    @movement = current_villa.outgoings.find(params[:id])
  end
end
