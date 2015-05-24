require 'test_helper'

class ViewTroopsTest < ActionDispatch::IntegrationTest
  test "should get an different views for movements" do
    one = login :one, TestMovementsController
    one.view_index_pages players(:one).villas.first
  end

  private

  module TestMovementsController
    def view_index_pages villa
      get "/villas/#{villa.id}/movements"

      assert_response :success

      get "/movements"

      assert_response :success
    end
  end
end
