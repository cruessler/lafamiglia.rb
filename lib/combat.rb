class Combat
  attr_accessor :winner
  attr_accessor :attacker, :defender
  attr_accessor :attack_value, :defense_value

  attr_reader :plundered_resources

  def initialize(attacker, defender)
    @attacker, @defender = attacker, defender
  end

  def calculate
    @attack_value = @defense_value = 0
    @plundered_resources = {}
    @unplundered_resources = {}

    LaFamiglia.units.each do |u|
      @attack_value += u.attack(attacker[u.key])
      @defense_value += u.defense(defender[u.key])
    end
    LaFamiglia.buildings.each do |b|
      @defense_value += b.defense(defender[b.key])
    end

    @winner = @attack_value > @defense_value ? :attacker : :defender

    case @winner
    when :attacker
      @attacker_percent_loss = (@defense_value.to_f / @attack_value) ** 1.5
      @defender_percent_loss = 1

      calculate_plundered_resources
    when :defender
      @attacker_percent_loss = 1
      @defender_percent_loss = (@attack_value.to_f / @defense_value) ** 1.5
    end
  end

  def calculate_plundered_resources
    LaFamiglia.resources.each do |resource|
      @plundered_resources[resource] = 0
      @unplundered_resources[resource] = @defender[resource]
    end

    load_remaining = LaFamiglia.units.inject(0) do |acc, unit|
      acc += unit.load attacker_after_combat[unit.key]
    end

    while load_remaining > 0
      resources_remaining = LaFamiglia.resources.inject(0) do |acc, resource|
        acc + @unplundered_resources[resource]
      end

      break unless resources_remaining > 0

      plunderable_per_resource = [ [ load_remaining, resources_remaining ].min / 3, 1 ].max

      LaFamiglia.resources.each do |resource|
        amount = [ plunderable_per_resource, @unplundered_resources[resource] ].min
        @unplundered_resources[resource] -= amount
        @plundered_resources[resource] += amount
        load_remaining -= amount
      end
    end
  end

  def attacker_can_occupy?
    if @attacker_can_occupy.nil?
      @attacker_can_occupy = attacker_after_combat[LaFamiglia.config.unit_for_occupation] > 0
    end

    @attacker_can_occupy
  end

  def occupation_began?
    attacker_can_occupy?
  end

  def attacker_survived?
    if @attacker_survived.nil?
      @attacker_survived = attacker_after_combat.any? { |pair| pair[1] > 0 }
    end

    @attacker_survived
  end

  def defender_survived?
    if @defender_survived.nil?
      @defender_survived = defender_after_combat.any? { |pair| pair[1] > 0 }
    end

    @defender_survived
  end

  def attacker_before_combat
    @attacker_before_combat ||= LaFamiglia.units.each_with_object({}) do |u, hash|
      hash[u.key] = @attacker[u.key]
    end
  end

  def defender_before_combat
    @defender_before_combat ||= LaFamiglia.units.each_with_object({}) do |u, hash|
      hash[u.key] = @defender[u.key]
    end
  end

  def attacker_loss
    @attacker_loss = LaFamiglia.units.each_with_object({}) do |u, hash|
      hash[u.key] = (@attacker[u.key] * @attacker_percent_loss).to_i
    end
  end

  def defender_loss
    @defender_loss = LaFamiglia.units.each_with_object({}) do |u, hash|
      hash[u.key] = (@defender[u.key] * @defender_percent_loss).to_i
    end
  end

  def attacker_after_combat
    @attacker_after_combat ||= LaFamiglia.units.each_with_object({}) do |u, hash|
      hash[u.key] = @attacker[u.key] - attacker_loss[u.key]
    end
  end

  def defender_after_combat
    @defender_after_combat ||= LaFamiglia.units.each_with_object({}) do |u, hash|
      hash[u.key] = @defender[u.key] - defender_loss[u.key]
    end
  end

  def attacker_supply_loss
    @attacker_supply_loss ||= LaFamiglia.units.inject(0) do |supply, u|
      supply + u.supply(attacker_loss[u.key])
    end
  end

  def defender_supply_loss
    @defender_supply_loss ||= LaFamiglia.units.inject(0) do |supply, u|
      supply + u.supply(defender_loss[u.key])
    end
  end

  def report_data *keys
    keys.each_with_object({}) do |key, hash|
      hash[key] = self.send key
    end
  end
end
