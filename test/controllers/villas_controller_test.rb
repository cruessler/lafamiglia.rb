require 'test_helper'

class VillasControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "a player without villa should automatically get a new one" do
    p = players :three
    sign_in p

    p.recalc_points!

    assert_equal 0, p.points
    assert_equal 0, p.villas.count

    get :index

    p.reload

    assert_not_equal 0, p.points
    assert_equal 1, p.villas.count
  end
end
