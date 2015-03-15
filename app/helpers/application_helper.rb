module ApplicationHelper
  def objects_for_selector objects
    ActiveSupport::JSON.encode objects
  end

  def bootstrap_alert alert_type, message
    render partial: 'common/bootstrap_alert',
           locals: { alert_type: alert_type, message: message }
  end

  def time_diff diff
    '%02d:%02d:%02d' % [ diff / 3600, (diff % 3600) / 60, diff % 60 ]
  end

  def countdown_to time
    content_tag :span,
                time_diff(time - LaFamiglia.now),
                class: 'countdown'
  end
end
