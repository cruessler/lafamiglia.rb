require 'test_helper'

class OccupiedVillaTest < ActionDispatch::IntegrationTest
  test "a different view is shown if a villa is occupied" do
    two = login :two, TestOccupiedVilla
    two.view_occupied_page villas(:occupied_villa)
  end

  private

  module TestOccupiedVilla
    def view_occupied_page villa
      get "/villas/#{villa.id}"

      assert_select "div.occupied-header"
      assert_select "div.occupied-info"
    end
  end
end
