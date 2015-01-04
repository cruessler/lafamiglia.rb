class CombatReport < Report
  def attacker_won?
    data[:winner] == 'attacker'
  end

  def origin
    @origin ||= Villa.find data[:origin_id]
  end

  def target
    @target ||= Villa.find data[:target_id]
  end

  def data
    @data ||= ActiveSupport::JSON.decode(read_attribute(:data)).with_indifferent_access
  end
end
