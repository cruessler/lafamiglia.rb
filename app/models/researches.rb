module LaFamiglia
  class Research
    def key
      "research_#{id}".to_sym
    end

    def name
      @name ||= I18n.t "researches.#{key}"
    end

    def requirements_met? villa
      villa.building_2 > 0
    end

    attr_accessor :id
    attr_accessor :maxlevel
    attr_writer :research_time, :costs

    def research_time level
      @research_time[level]
    end

    def costs level
      @costs[level]
    end
  end

  @@researches ||= []

  def @@researches.add
    @@researches.push(Research.new)

    yield @@researches.last
  end

  def @@researches.get_by_id research_id
    @@researches.find do |r|
      r.id == research_id
    end
  end

  mattr_accessor :researches

  module Researches
    module Readers
      def researches
        LaFamiglia.researches.each_with_object({}) do |r, hash|
          hash[r.key] = self.send(r.key)
        end
      end
    end
  end
end
