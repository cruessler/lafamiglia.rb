class Report < ActiveRecord::Base
  belongs_to :player

  before_create :set_default_values
  after_create :increment_unread_counter_cache_for_player

  def set_default_values
    self.read = false
  end

  def increment_unread_counter_cache_for_player
    player.increment! :unread_reports_count
  end

  def mark_as_read!
    update_attribute :read, true
    player.decrement! :unread_messages_count
  end
end
