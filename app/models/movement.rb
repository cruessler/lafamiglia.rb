class Movement < ActiveRecord::Base
  include LaFamiglia::Resources::Accessors
  include LaFamiglia::Units::Accessors

  belongs_to :origin, class_name: 'Villa'
  belongs_to :target, class_name: 'Villa'

  validates_presence_of :origin
  validates_presence_of :target

  before_validation :set_default_values, on: :create

  after_validation :calculate_arrives_at, on: :create

  def set_default_values
    self.unit_1 = 0 if self.unit_1.nil?
    self.unit_2 = 0 if self.unit_2.nil?
    self.resource_1 = 0 if self.resource_1.nil?
    self.resource_2 = 0 if self.resource_2.nil?
    self.resource_3 = 0 if self.resource_3.nil?
  end

  def calculate_arrives_at
    self.arrives_at = LaFamiglia.now + duration if self.arrives_at.nil?
  end

  def duration
    @duration ||= begin
      distance = Math.hypot origin.x - target.x, origin.y - target.y
      distance / speed
    end
  end

  def speed
    @speed ||= LaFamiglia.units.reject { |unit| self[unit.key] < 1 }
                               .collect { |unit| unit.speed }.min.to_f / 3600
  end
end
