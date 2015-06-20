require 'test_helper'

class BuildResearchRecruitTest < ActionDispatch::IntegrationTest
  test "links to cancel orders are shown" do
    one = login :one, TestBuildResearchRecruit
    villa = villas :villa_having_lots_of_resources

    one.build_buildings villa
    one.do_research villa
    one.recruit_units villa
  end

  private

  module TestBuildResearchRecruit
    def build_buildings villa
      post_via_redirect "/villas/#{villa.id}/building_queue_items?building_id=1"

      item = BuildingQueueItem.last

      assert_select "a[href='/villas/#{villa.id}/building_queue_items/#{item.id}']"
    end

    def do_research villa
      post_via_redirect "/villas/#{villa.id}/research_queue_items?research_id=1"

      item = ResearchQueueItem.last

      assert_select "a[href='/villas/#{villa.id}/research_queue_items/#{item.id}']"
    end

    def recruit_units villa
      post_via_redirect "/villas/#{villa.id}/unit_queue_items?unit_id=1&number=5"

      item = UnitQueueItem.last

      assert_select "a[href='/villas/#{villa.id}/unit_queue_items/#{item.id}']"
    end
  end
end
