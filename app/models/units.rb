module LaFamiglia
  class Unit
    def key
      "unit_#{id}".to_sym
    end

    def name
      @name ||= I18n.t "units.#{key}"
    end

    def building
      @building ||= LaFamiglia.building building_id
    end

    def requirements_met? villa
      true
    end
  end

  class Beppo < Unit
    def id
      1
    end

    def build_time number = 1
      number * 2
    end

    def costs number = 1
      {
        resource_1: number * 1,
        resource_2: 0,
        resource_3: number * 1
      }
    end

    def supply number = 1
      number * 2
    end

    def building_id
      1
    end
  end

  UNITS = [ Beppo.new ]

  def self.unit unit_id
    UNITS.find do |u|
      u.id == unit_id
    end
  end
end
