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
end
