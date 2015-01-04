class ReportsController < ApplicationController
  power :reports

  before_action :set_report, only: [ :show ]

  # GET /reports/1
  def show
  end

  # GET /reports
  def index
    @reports = current_power.reports.order 'time DESC'
  end

  private

  def set_report
    @report = current_power.reports.find(params[:id])
  end
end
