module PlayerHelper
  def unread_items_badge
    badge_for(current_player.unread_messages_count + current_player.unread_reports_count)
  end

  def unread_messages_badge
    badge_for current_player.unread_messages_count
  end

  def unread_reports_badge
    badge_for current_player.unread_reports_count
  end

  def badge_for count
    if count > 0
      content_tag :span, count, class: 'badge'
    end
  end
end
