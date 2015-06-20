require 'test_helper'

class CombatReportTest < ActiveSupport::TestCase
  test "should deliver two combat reports" do
    origin, target = villas(:occupying_villa, :villa_to_be_occupied)

    assert_difference -> { CombatReport.count }, 2 do
      create_and_handle_attack origin, target
    end

    first_report, second_report = CombatReport.order('id DESC').limit(2).all

    assert_not_equal first_report.player, second_report.player
    assert_not_nil first_report.occupation_began?
    assert_not_nil second_report.data[:occupation_began?]
    assert_instance_of HashWithIndifferentAccess, first_report.data
  end

  test "should include plundered resources in report" do
    origin, target = villas(:villa_having_lots_of_units,
                            :villa_having_few_units)

    create_and_handle_attack origin, target

    assert_instance_of HashWithIndifferentAccess, Report.last.data[:plundered_resources]
  end
end

