class CombatReport < Report
  def attacker_won?
    data[:winner] == 'attacker'
  end
end
