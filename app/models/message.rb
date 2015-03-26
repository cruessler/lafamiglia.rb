class Message < ActiveRecord::Base
  belongs_to :sender, class_name: "Player"
  has_many :message_statuses
  has_and_belongs_to_many :receivers, class_name: "Player", join_table: "messages_receivers"

  validates_presence_of :sender, on: :create
  validates_presence_of :receivers, on: :create
  validates_presence_of :text, on: :create

  before_create :set_sent_at
  after_create :create_message_statuses
  after_create :increment_unread_counter_cache_for_player
  before_validation :remove_sender_from_receivers

  def remove_sender_from_receivers
    self.receivers = receivers.reject { |r| r.id == sender.id }
  end

  def set_sent_at
    self.sent_at = LaFamiglia.now
  end

  def create_message_statuses
    message_statuses.create(player: sender, read: true)

    receivers.each do |r|
      message_statuses.create(player: r)
    end
  end

  def increment_unread_counter_cache_for_player
    receivers.each do |r|
      r.increment! :unread_messages_count
    end
  end

  def status_for player
    message_statuses.find_by(player: player)
  end
end
