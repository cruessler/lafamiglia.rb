class MessageStatus < ActiveRecord::Base
  belongs_to :player
  belongs_to :message

  after_create :set_default_values
  after_destroy :destroy_associated_message_if_necessary

  def set_default_values
    self.read = false if self.read.nil?
  end

  def destroy_associated_message_if_necessary
    if message.message_statuses.count == 0
      message.destroy
    end
  end
end
