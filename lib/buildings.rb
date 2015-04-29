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

    attr_accessor :id
    attr_accessor :maxlevel
    attr_writer :build_time, :costs, :defense, :points

    def build_time level
      @build_time[level] / LaFamiglia.config.game_speed
    end

    def costs level
      @costs[level]
    end

    def defense level
      @defense[level]
    end

    def points level
      @points[level].to_i
    end
  end

  @@buildings ||= []

  def @@buildings.add
    @@buildings.push(Building.new)

    yield @@buildings.last
  end

  def @@buildings.get_by_id building_id
    @@buildings.find do |b|
      b.id == building_id
    end
  end

  mattr_accessor :buildings

  module Buildings
    module Readers
      def buildings
        LaFamiglia.buildings.each_with_object({}) do |b, hash|
          hash[b.key] = self.send(b.key)
        end
      end
    end
  end
end
