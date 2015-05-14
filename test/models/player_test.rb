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

    Report.transaction do
      1.upto(10) do |i|
        Report.create(player:       sender,
                      read:         false,
                      title:        "This is a title",
                      delivered_at: LaFamiglia.now)
      end
    end

    assert_equal 10, sender.unread_reports_count

    Report.transaction do
      sender.reports[-2..-1].each do |r|
        r.mark_as_read!
      end
    end

    assert_equal 8, sender.unread_reports_count
  end

  test "should have 0 points after creation" do
    p = Player.create name: 'New player',
                      email: 'pl@ay.er',
                      password: 'unsafe password',
                      password_confirmation: 'unsafe password'

    assert_equal 0, p.points
  end
end
