module ResearchQueueExtension
  def last_of_its_kind? queue_item
    research = LaFamiglia.researches.get_by_id queue_item.research_id

    reverse.each do |i|
      break if i == queue_item

      if i.research_id == research.id
        return false
      end
    end

    return true
  end

  def enqueued_count research
    # See BuildingQueueExtension#enqueued_count.
    select do |i|
      i.research_id == research.id
    end.length
  end

  def refunds queue_item, time_diff
    research = LaFamiglia.researches.get_by_id queue_item.research_id

    refund_ratio = time_diff.to_f / queue_item.research_time
    previous_level = villa.virtual_research_level(research) - 1
    refunds = research.costs previous_level

    refunds.each_pair do |k, v|
      refunds[k] = v * refund_ratio
    end

    refunds
  end

  def virtual_level research
    villa.virtual_research_level research
  end

  def build_item research, level
    research_time = research.research_time(level)
    proxy_association.build(research_id: research.id,
                            research_time: research_time,
                            completed_at: completed_at + research_time)
  end

  def error_message key
    I18n.t("errors.researches.#{key}")
  end
end
