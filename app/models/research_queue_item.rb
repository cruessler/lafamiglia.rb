class ResearchQueueItem < ActiveRecord::Base
  belongs_to :villa, counter_cache: true

  def research
    @research ||= LaFamiglia.research research_id
  end
end
