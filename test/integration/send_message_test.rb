require 'test_helper'

class SendMessageTest < ActionDispatch::IntegrationTest
  test "players can send messages" do
    session_one = login :one, TestSendMessage
    session_two = login :two, TestSendMessage
    one = players :one
    two = players :two

    assert_difference -> { two.message_statuses.where(read: false).count } do
      session_one.send_message_to two, "This is a message."
    end

    assert_difference -> { one.message_statuses.where(read: false).count } do
      session_two.send_message_to one, "This is a message."
    end
  end

  private

  module TestSendMessage
    def send_message_to receiver, message
      get "/messages"
      post "/messages", { message: { receiver_ids: [ receiver.id ],
                                     text: message } },
                        { referer: messages_path }
    end
  end
end
