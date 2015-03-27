class Report < ActiveRecord::Base
  belongs_to :player

  validates_inclusion_of :read, in: [ true, false ]

  after_create :increment_unread_counter_cache_for_player

  def increment_unread_counter_cache_for_player
    player.increment! :unread_reports_count
  end

  def mark_as_read!
    update_attribute :read, true
    player.decrement! :unread_messages_count
  end
end
