require 'test_helper'

class MessageCountTest < ActionDispatch::IntegrationTest
  setup do
    Message.transaction do
      1.upto(10) do |i|
        Message.create(sender:    players(:two),
                       receivers: [ players(:one) ],
                       text:      "This is a message.")
      end
    end
  end

  test "has valid counter caches" do
    one = login :one, TestHasValidCounterCaches
    one.view_unread_message
  end

  private

  module TestHasValidCounterCaches
    def view_unread_message
      get "/"
      assert_response :success

      player = assigns(:current_player)
      assert_equal player.unread_messages_count,
                   player.message_statuses.where(read: false).count

      unread_message_status = player.message_statuses.where(read: false).first

      get "/messages/#{unread_message_status.message_id}"

      player = assigns(:current_player)
      assert_equal player.unread_messages_count,
                   player.message_statuses.where(read: false).count
    end
  end
end
