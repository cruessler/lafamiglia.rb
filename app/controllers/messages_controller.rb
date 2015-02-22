class MessagesController < ApplicationController
  power :messages

  before_action :set_message, only: [ :show, :destroy ]

  # GET /messages/1
  def show
  end

  # GET /messages
  def index
    @message_statuses = current_power.message_statuses.includes(:message)
  end

  # DELETE /messages/1
  def destroy
    @message_status.destroy
    redirect_to messages_url, notice: t('.deleted')
  end

  private

  def set_message
    @message = current_power.messages.find(params[:id])
    @message_status = @message.status_for current_player
    @message_status.mark_as_read! unless @message_status.read
  end
end
