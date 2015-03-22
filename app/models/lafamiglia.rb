require_dependency 'buildings'
require_dependency 'researches'
require_dependency 'units'

module LaFamiglia
  def self.clock now = Time.now
    @@now = now
  end

  def self.now
    @@now
  end

  def self.max_x
    10
  end

  def self.max_y
    10
  end

  def self.unit_speed
    10
  end

  RESOURCES = [ :resource_1, :resource_2, :resource_3 ]

  module Resources
    module Accessors
      def resources
        LaFamiglia::RESOURCES.each_with_object({}) do |r, hash|
          hash[r] = self.send r
        end
      end

      def resources= resources
        LaFamiglia::RESOURCES.each do |r|
          self[r] = resources[r]
        end
      end
    end
  end
end
