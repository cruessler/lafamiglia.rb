class Movement < ActiveRecord::Base
  include LaFamiglia::Resources::Readers
  include LaFamiglia::Units::Accessors

  belongs_to :origin, class_name: 'Villa'
  belongs_to :target, class_name: 'Villa'

  validates_presence_of :origin
  validates_presence_of :target
  validates_presence_of :unit_1

  after_initialize :set_default_values

  def set_default_values
    self.unit_1 = 0 if self.unit_1.nil?
    self.resource_1 = 0 if self.resource_1.nil?
    self.resource_2 = 0 if self.resource_2.nil?
    self.resource_3 = 0 if self.resource_3.nil?
  end

  def duration
    @duration ||= begin
      distance = Math.hypot origin.x - target.x, origin.y - target.y
      distance / speed
    end
  end

  def speed
    @speed ||= LaFamiglia::UNITS
      .reject { |unit| self[unit.key] < 1 }
      .collect { |unit| unit.speed }.min.to_f / 3600
  end
end
