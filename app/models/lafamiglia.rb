module LaFamiglia
  def self.clock
    @@now = Time.now.to_i
  end

  def self.now
    @@now
  end

  def self.max_x
    10
  end

  def self.max_y
    10
  end
end
