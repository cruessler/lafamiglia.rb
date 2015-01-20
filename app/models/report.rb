class Report < ActiveRecord::Base
  belongs_to :player

  after_initialize :set_default_values

  def set_default_values
    self.read = false if self.read.nil?
  end

  def mark_as_read!
    update_attribute :read, true
  end
end
