class MessagesController < ApplicationController
  # GET /messages
  def index
    @message_statuses = current_power.message_statuses.includes(:message)
  end
end
