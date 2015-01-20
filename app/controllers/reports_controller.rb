class ReportsController < ApplicationController
  power :reports

  before_action :set_report, only: [ :show, :destroy ]

  # GET /reports/1
  def show
  end

  # GET /reports
  def index
    @reports = current_power.reports.order 'time DESC'
  end

  # DELETE /reports/1
  def destroy
    @report.destroy
    redirect_to reports_url, notice: t('.deleted')
  end

  private

  def set_report
    @report = current_power.reports.find(params[:id])
    @report.mark_as_read! unless @report.read
  end
end
