class Combat
  attr_accessor :winner
  attr_accessor :attacker, :defender

  def initialize(attacker, defender)
    @attacker, @defender = attacker, defender
  end

  def calculate
    @attack_value = @defense_value = 0

    LaFamiglia::UNITS.each do |u|
      @attack_value += u.attack(attacker[u.key])
      @defense_value += u.defense(defender[u.key])
    end
    LaFamiglia::BUILDINGS.each do |b|
      @defense_value += b.defense(defender[b.key])
    end

    @winner = @attack_value > @defense_value ? :attacker : :defender

    case @winner
    when :attacker
      @attacker_percent_loss = (@defense_value.to_f / @attack_value) ** 1.5
      @defender_percent_loss = 1
    when :defender
      @attacker_percent_loss = 1
      @defender_percent_loss = (@attack_value.to_f / @defense_value) ** 1.5
    end

    puts "attacker: #{@attacker}, defender: #{@defender}"
    puts "attack value: #{@attack_value}, defense value: #{@defense_value}"
    puts "attacker loss: #{attacker_loss}, defender loss: #{defender_loss}"
  end

  def attacker_survived?
    @attacker_survived ||= attacker_after_combat.any? { |pair| pair[1] > 0 }
  end

  def attacker_before_combat
    @attacker_before_combat ||= LaFamiglia::UNITS.each_with_object({}) do |u, hash|
      hash[u.key] = @attacker[u.key]
    end
  end

  def defender_before_combat
    @defender_before_combat ||= LaFamiglia::UNITS.each_with_object({}) do |u, hash|
      hash[u.key] = @defender[u.key]
    end
  end

  def attacker_loss
    @attacker_loss = LaFamiglia::UNITS.each_with_object({}) do |u, hash|
      hash[u.key] = (@attacker[u.key] * @attacker_percent_loss).to_i
    end
  end

  def defender_loss
    @defender_loss = LaFamiglia::UNITS.each_with_object({}) do |u, hash|
      hash[u.key] = (@defender[u.key] * @defender_percent_loss).to_i
    end
  end

  def attacker_after_combat
    @attacker_after_combat ||= LaFamiglia::UNITS.each_with_object({}) do |u, hash|
      hash[u.key] = @attacker[u.key] - attacker_loss[u.key]
    end
  end

  def attacker_supply_loss
    @attacker_supply_loss ||= LaFamiglia::UNITS.inject(0) do |supply, u|
      supply + u.supply(attacker_loss[u.key])
    end
  end

  def defender_supply_loss
    @defender_supply_loss ||= LaFamiglia::UNITS.inject(0) do |supply, u|
      supply + u.supply(defender_loss[u.key])
    end
  end

  def report_data
    { winner: winner,
      attacker_before_combat: attacker_before_combat,
      attacker_loss: attacker_loss,
      defender_before_combat: defender_before_combat,
      defender_loss: defender_loss }
  end
end
