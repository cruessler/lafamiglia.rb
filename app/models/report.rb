class Report < ActiveRecord::Base
  belongs_to :player

  serialize :data, JSON

  validates_inclusion_of :read, in: [ true, false ]

  after_create :increment_unread_counter_cache_for_player

  def self.report_data *keys
    keys.each do |k|
      define_method k do
        self.data[k]
      end
    end
  end

  def increment_unread_counter_cache_for_player
    player.increment! :unread_reports_count
  end

  def mark_as_read!
    update_attribute :read, true
    player.decrement! :unread_reports_count
  end

  def data
    @data ||= self[:data].with_indifferent_access
  end

  def origin
    @origin ||= Villa.find data[:origin_id]
  end

  def target
    @target ||= Villa.find data[:target_id]
  end
end
