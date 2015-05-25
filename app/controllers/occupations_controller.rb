class OccupationsController < ApplicationController
  before_action :set_occupation, only: [ :destroy ]

  # DELETE /occupations/1
  def destroy
    comeback = @occupation.cancel!

    notify_dispatcher comeback.arrives_at

    redirect_to :back, notice: I18n.t('occupations.cancelled')
  end

  private

  def set_occupation
    @occupation = current_villa.occupations.find(params[:id])
  end
end
