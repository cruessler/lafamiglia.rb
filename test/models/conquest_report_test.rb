require 'test_helper'

class ConquestReportTest < ActiveSupport::TestCase
  setup do
    setup_for_occupation_test
  end

  test "should deliver two conquest reports" do
    old_number_of_reports = ConquestReport.count

    assert_difference -> { ConquestReport.count }, 2 do
      create_and_handle_occupation @origin, @target
    end

    first_report, second_report = ConquestReport.order('id DESC').limit(2).all

    assert_not_equal first_report.player, second_report.player
  end
end
