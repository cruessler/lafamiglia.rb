class ReportsController < ApplicationController
  # GET /reports
  def index
    @reports = current_power.reports
  end
end
