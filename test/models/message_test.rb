require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  setup do
    @m = Message.create(sender: Player.first,
                        text: "This is a message.",
                        receivers: [ Player.second ])
  end

  test "should have message statuses" do
    assert_equal 2, @m.message_statuses.count
  end

  test "should destroy message when last status is destroyed" do
    @m.message_statuses.each do |s|
      s.destroy
    end

    assert @m.destroyed?
  end
end
