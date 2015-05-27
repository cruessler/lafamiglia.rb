class CombatReport < Report
  # data is a hash containing the following keys:
  #   origin_id
  #   target_id
  #   winner: attacker or defender
  #   attacker_before_combat
  #   attacker_loss
  #   defender_before_combat
  #   defender_loss
  #   plundered_resources
  #   occupation_began

  def attacker_won?
    data[:winner] == 'attacker'
  end

  def occupation_began?
    data[:occupation_began]
  end
end
