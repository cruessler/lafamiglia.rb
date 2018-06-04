class MessagesController < ApplicationController
  power :messages

  before_action :set_message, only: [ :show, :destroy ]

  # GET /messages/1
  def show
  end

  def create
    @message = Message.create_with(sender: current_player)
                      .new(message_params)

    respond_to do |format|
      if @message.save
        format.html do
          redirect_back(fallback_location: root_path, notice: t('.created'))
        end
      else
        format.html do
          set_message_statuses
          render action: 'index'
        end
      end
    end
  end

  # GET /messages
  def index
    @message = Message.new
    set_message_statuses
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

    unless @message_status.read
      @message_status.mark_as_read!
      current_player.decrement :unread_messages_count
    end
  end

  def set_message_statuses
    @message_statuses = current_power.message_statuses.includes(:message)
                                                      .order('messages.sent_at DESC')
  end

  def message_params
    params.require(:message).permit(:text, :receiver_ids => [])
  end
end
