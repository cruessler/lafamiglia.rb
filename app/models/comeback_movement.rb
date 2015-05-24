class ComebackMovement < Movement
  def cancellable?
    false
  end

  def arrive!
    origin.add_resources! resources
    origin.add_units! units

    transaction do
      destroy
      origin.save
    end
  end

  def to_s include_origin = true
    if include_origin
      "#{origin} ← #{target}"
    else
      "← #{target}"
    end
  end
end
