class Occupation < ActiveRecord::Base
  include LaFamiglia::Units::Accessors

  belongs_to :origin, class_name: 'Villa'
  belongs_to :target, class_name: 'Villa'

  after_validation :set_succeeds_at, on: :create
  after_create :set_is_occupied_for_villa
  after_destroy :unset_is_occupied_for_villa

  def set_succeeds_at
    self.succeeds_at = LaFamiglia.now + target.duration_of_occupation
  end

  def set_is_occupied_for_villa
    target.update_attribute :is_occupied, true
  end

  def unset_is_occupied_for_villa
    target.update_attribute :is_occupied, false
  end

  def cancel!
    comeback = ComebackMovement.new(origin: origin,
                                    target: target,
                                    units: units)

    transaction do
      destroy
      comeback.save

      comeback
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
