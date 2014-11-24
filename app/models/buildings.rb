module LaFamiglia
  class Building
    def key
      "building_#{id}".to_sym
    end

    def name
      @name ||= I18n.t "buildings.#{key}"
    end
  end

  class HouseOfTheFamily < Building
    def id
      1
    end

    def build_time level
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

  BUILDINGS = [ HouseOfTheFamily.new ]

  def self.building building_id
    BUILDINGS.find do |b|
      b.id == building_id
    end
  end
end
