require 'test_helper'

class FirstLoginTest < ActionDispatch::IntegrationTest
  test "login and have a villa" do
    one = login :one, TestVillaGetsCreated
    one.view_index
  end

  private

  module TestVillaGetsCreated
    def view_index
      get "/"
      assert_response :success

      villa = assigns(:current_villa)
      assert_not_nil villa
      assert_equal 0, villa.used_supply
    end
  end
end
