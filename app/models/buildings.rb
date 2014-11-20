module LaFamiglia
  class Building
    def name
      @name ||= I18n.t "buildings.#{key}"
    end
  end

  class HouseOfTheFamily < Building
    def id
      1
    end

    def key
      :house_of_the_family
    end

    def build_time level
      level * 1 + 4
    end

    def costs level
      {
        pizzas: level * 1 + 1,
        concrete: level * 1 + 1,
        suits: level * 1 + 1
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
