class AttackMovement < Movement
  validate :enough_units, :units_selected,
           :target_not_owned_by_attacker

  after_validation :calculate_arrival, on: :create

  after_create :subtract_units_from_origin!

  def enough_units
    LaFamiglia::UNITS.each do |u|
      number = self.send(u.key)
      errors.add(u.key, I18n.t('errors.movements.invalid_number')) unless number > 0 && number <= origin.unit_number(u)
    end
  end

  def units_selected
    total = LaFamiglia::UNITS.inject(0) do |sum, u|
      if (number = self.send(u.key)) > 0
        sum + number
      else
        sum
      end
    end

    errors.add(:base, I18n.t('errors.movements.no_unit_selected')) unless total > 0
  end

  def target_not_owned_by_attacker
    errors.add(:base, I18n.t('errors.movements.target_is_own')) if target.player == origin.player
  end

  def calculate_arrival
    self.arrival = LaFamiglia.now + duration
  end

  def subtract_units_from_origin!
    origin.subtract_units! units
    origin.save
  end

  def cancellable?
    arrival > LaFamiglia.now
  end

  def cancel!
    #           = LaFamiglia.now + duration - (arrival - LaFamiglia.now)
    new_arrival = LaFamiglia.now + LaFamiglia.now - arrival + duration
    new_attributes = attributes
    new_attributes.delete('type')
    new_attributes[:arrival] = new_arrival
    comeback = ComebackMovement.new(new_attributes)
    transaction do
      destroy
      comeback.save
    end
  end
end
