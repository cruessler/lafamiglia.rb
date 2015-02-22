class Message < ActiveRecord::Base
  belongs_to :sender, class_name: "Player"
  has_many :message_statuses
  has_and_belongs_to_many :receivers, class_name: "Player", join_table: "messages_receivers"

  validates_presence_of :sender, on: :create
  validates_presence_of :receivers, on: :create
  validates_presence_of :text, on: :create

  before_create :set_time
  after_create :create_message_statuses

  def set_time
    time = LaFamiglia.now
  end

  def create_message_statuses
    message_statuses.create(player: sender)

    receivers.each do |r|
      message_statuses.create(player: r)
    end
  end

  def status_for player
    message_statuses.find_by(player: player)
  end
end
