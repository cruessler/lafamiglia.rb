require 'test_helper'

class MovementTest < ActiveSupport::TestCase
  setup do
    @m = Movement.create(origin: villas(:one),
                        target: villas(:two),
                        unit_1: 1)
  end

  test "movement should have positive speed" do
    assert @m.speed > 0
  end

  test "movement should have a positive duration" do
    assert @m.duration > 0
  end
end
