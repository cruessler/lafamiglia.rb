module LaFamiglia
  class Unit
    def key
      "unit_#{id}".to_sym
    end

    def name
      @name ||= I18n.t "units.#{key}"
    end

    def building
      @building ||= LaFamiglia.buildings.get_by_id building_id
    end

    def requirements_met? villa
      true
    end

    attr_accessor :id, :building_id
    attr_writer :build_time, :costs, :supply,
                :speed, :attack, :defense, :load

    def build_time number = 1
      number * @build_time / LaFamiglia.config.game_speed
    end

    def costs number = 1
      {
        resource_1: number * @costs[:resource_1],
        resource_2: number * @costs[:resource_2],
        resource_3: number * @costs[:resource_3]
      }
    end

    def supply number = 1
      number * @supply
    end

    def speed
      @speed * LaFamiglia.config.unit_speed
    end

    def attack number
      number * @attack
    end

    def defense number
      number * @defense
    end

    def load number
      number * @load
    end
  end

  @@units ||= []

  def @@units.add
    @@units.push(Unit.new)

    yield @@units.last
  end

  def @@units.get_by_id unit_id
    @@units.find do |u|
      u.id == unit_id
    end
  end

  mattr_accessor :units

  module Units
    module Accessors
      def units
        LaFamiglia.units.each_with_object({}) do |u, hash|
          hash[u.key] = self.send(u.key)
        end
      end

      def units= units
        LaFamiglia.units.each do |u|
          self[u.key] = units[u.key]
        end
      end
    end
  end
end
