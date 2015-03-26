require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "should have correct counter caches" do
    sender   = players(:one)
    receiver = players(:two)

    Message.transaction do
      1.upto(10) do |i|
        Message.create(sender:    sender,
                       receivers: [ receiver ],
                       text:      "This is a message.")
      end
    end

    assert_equal 10, receiver.unread_messages_count

    Message.transaction do
      receiver.message_statuses[-2..-1].each do |s|
        s.mark_as_read!
      end
    end

    assert_equal 8, receiver.unread_messages_count
  end
end
