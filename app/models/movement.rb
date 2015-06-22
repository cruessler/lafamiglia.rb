class Movement < ActiveRecord::Base
  include LaFamiglia::Resources::Accessors
  include LaFamiglia::Units::Accessors

  belongs_to :origin, class_name: 'Villa'
  belongs_to :target, class_name: 'Villa'

  validates_presence_of :origin
  validates_presence_of :target
  validate :villa_not_occupied

  before_validation :set_default_values, on: :create

  after_validation :calculate_arrives_at, on: :create

  def villa_not_occupied
    errors.add(:base, I18n.t('errors.movements.villa_is_occupied')) if origin.occupied?
  end

  def enough_units
    LaFamiglia.units.each do |u|
      number = self.send(u.key)
      errors.add(u.key, I18n.t('errors.movements.invalid_number')) unless number >= 0 && number <= origin.unit_number(u)
    end
  end

  def units_selected
    errors.add(:base, I18n.t('errors.movements.no_unit_selected')) unless has_units?
  end

  def set_default_values
    self.unit_1 = 0 if self.unit_1.nil?
    self.unit_2 = 0 if self.unit_2.nil?
    self.resource_1 = 0 if self.resource_1.nil?
    self.resource_2 = 0 if self.resource_2.nil?
    self.resource_3 = 0 if self.resource_3.nil?
  end

  def calculate_arrives_at
    if has_units?
      self.arrives_at = LaFamiglia.now + duration if self.arrives_at.nil?
    end
  end

  def units_count
    @units_count ||= LaFamiglia.units.inject(0) do |sum, u|
      if (number = self[u.key]) > 0
        sum + number
      else
        sum
      end
    end
  end

  def has_units?
    units_count > 0
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
