module LaFamiglia
  class Building
    def key
      "building_#{id}".to_sym
    end

    def name
      @name ||= I18n.t "buildings.#{key}"
    end

    def requirements_met? villa
      true
    end

    def defense level
      0
    end
  end

  module Buildings
    module Readers
      def buildings
        LaFamiglia::BUILDINGS.each_with_object({}) do |b, hash|
          hash[b.key] = self.send(b.key)
        end
      end
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

    def defense level
      10
    end
  end

  class InventorsHouse < Building
    def id
      2
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
      10
    end
  end

  BUILDINGS = [ HouseOfTheFamily.new, InventorsHouse.new ]

  def self.building building_id
    BUILDINGS.find do |b|
      b.id == building_id
    end
  end
end
