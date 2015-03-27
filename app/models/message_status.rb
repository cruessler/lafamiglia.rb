class MessageStatus < ActiveRecord::Base
  belongs_to :player
  belongs_to :message

  validates_inclusion_of :read, in: [ true, false ]

  after_destroy :destroy_associated_message_if_necessary

  def destroy_associated_message_if_necessary
    if message.message_statuses.count == 0
      message.destroy
    end
  end

  def mark_as_read!
    update_attribute :read, true
    player.decrement! :unread_messages_count
  end
end
