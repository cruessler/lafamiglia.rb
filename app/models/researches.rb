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
  end

  module Researches
    module Readers
      def researches
        LaFamiglia::RESEARCHES.each_with_object({}) do |r, hash|
          hash[r.key] = self.send(r.key)
        end
      end
    end
  end

  class TommyGun < Research
    def id
      1
    end

    def research_time level
      level * 1 + 4
    end

    def costs level
      {
        resource_1: level * 1 + 1,
        resource_2: level * 1 + 1,
        resource_3: level * 1 + 1
      }
    end

    def maxlevel
      8
    end
  end

  RESEARCHES = [ TommyGun.new ]

  def self.research research_id
    RESEARCHES.find do |r|
      r.id == research_id
    end
  end
end
