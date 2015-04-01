class ResearchQueueItem < ActiveRecord::Base
  belongs_to :villa, counter_cache: true

  def research
    @research ||= LaFamiglia.researches.get_by_id research_id
  end
end
