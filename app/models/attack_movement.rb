class AttackMovement < Movement
  validate :enough_units, :units_selected,
           :target_not_owned_by_attacker

  after_create :subtract_units_from_origin!

  def enough_units
    LaFamiglia.units.each do |u|
      number = self.send(u.key)
      errors.add(u.key, I18n.t('errors.movements.invalid_number')) unless number >= 0 && number <= origin.unit_number(u)
    end
  end

  def units_selected
    errors.add(:base, I18n.t('errors.movements.no_unit_selected')) unless has_units?
  end

  def target_not_owned_by_attacker
    errors.add(:base, I18n.t('errors.movements.target_is_own')) if target.player == origin.player
  end

  def subtract_units_from_origin!
    origin.subtract_units! units
    origin.save
  end

  def cancellable?
    arrives_at > LaFamiglia.now
  end

  def cancel!
    # new_arrives_at = LaFamiglia.now + duration_of_return
    # duration_of_return = duration - time_remaining
    # time_remaining = arrives_at - LaFamiglia.now
    new_arrives_at = LaFamiglia.now + duration - (arrives_at - LaFamiglia.now)
    new_attributes = attributes
    new_attributes.delete('type')
    new_attributes[:arrives_at] = new_arrives_at

    comeback = ComebackMovement.new(new_attributes)

    transaction do
      destroy
      comeback.save

      comeback
    end
  end

  def attack_values
    units.merge(origin.researches)
  end

  def defense_values
    if target.occupied?
      origin_of_occupation = target.occupation.origin

      target.buildings.merge(target.occupation.units)
          .merge(origin_of_occupation.researches)
          .merge(target.resources)
    else
      target.buildings.merge(target.units)
          .merge(target.researches)
          .merge(target.resources)
    end
  end

  def to_s include_origin = true
    if include_origin
      "#{origin} → #{target}"
    else
      "→ #{target}"
    end
  end
end
