module ApplicationHelper
  def bootstrap_alert alert_type, message
    render partial: 'common/bootstrap_alert', locals: { alert_type: alert_type, message: message }
  end
end
