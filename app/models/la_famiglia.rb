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

  def self.config
    @@config ||= Configuration.new
  end

  def self.resources
    [ :resource_1, :resource_2, :resource_3 ]
  end

  module Resources
    module Accessors
      def resources
        LaFamiglia.resources.each_with_object({}) do |r, hash|
          hash[r] = self.send r
        end
      end

      def resources= resources
        LaFamiglia.resources.each do |r|
          self[r] = resources[r]
        end
      end
    end
  end
end
