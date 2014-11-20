require_dependency 'lafamiglia'
require_dependency 'extensions/building_queue_extension'

class Villa < ActiveRecord::Base
  belongs_to :player

  has_many :building_queue_items, -> { extending BuildingQueueExtension }

  before_create :set_default_values

  def self.find_unused_coordinates(x_range = 0..LaFamiglia.max_x, y_range = 0..LaFamiglia.max_y)
    x_range_length = x_range.size
    y_range_length = y_range.size

    if Villa.where([ 'x BETWEEN ? AND ? AND y BETWEEN ? AND ?',
                     x_range.first, x_range.last, y_range.first, y_range.last ]).count <
        x_range_length * y_range_length

      return [ x_range.first, y_range.first ] if x_range_length * y_range_length == 1

      if x_range_length < y_range_length
        new_y_ranges = [ y_range.first..(y_range.first + y_range_length / 2 - 1),
          (y_range.first + y_range_length / 2)..y_range.last ].sort_by { rand }
        find_unused_coordinates(x_range, new_y_ranges.first) or
          find_unused_coordinates(x_range, new_y_ranges.last)
      else
        new_x_ranges = [ x_range.first..(x_range.first + x_range_length / 2 - 1),
          (x_range.first + x_range_length / 2)..x_range.last ].sort_by { rand }
        find_unused_coordinates(new_x_ranges.first, y_range) or
          find_unused_coordinates(new_x_ranges.last, y_range)
      end
    end
  end

  def self.create_for player
    coordinates = find_unused_coordinates
    return nil unless coordinates

    Villa.create(x: coordinates[0], y: coordinates[1], name: I18n.t('villa.default_name'), player: player)
  end

  def set_default_values
    self.last_processed = LaFamiglia.now
    self.building_queue_items_count = 0

    self.storage_capacity = 100
    self.pizzas = self.concrete = self.suits = 0

    self.house_of_the_family = 1
  end

  def process_until!(timestamp)
    if building_queue_items_count > 0
      finished_items = building_queue_items.finished_until timestamp

      transaction do
        finished_items.each do |i|
          gain_resources_until! i.completion_time
          increment(i.building.key)
          building_queue_items.destroy i
        end

        gain_resources_until! timestamp
        save
      end
    else
      gain_resources_until! timestamp
    end
  end

  def gain_resources_until! timestamp
    time_diff = timestamp - self.last_processed

    if time_diff != 0
      add_resources!(resource_gains time_diff)
    end

    self.last_processed = timestamp
  end

  def add_resources!(resources)
    self.pizzas = [ self.pizzas + resources[:pizzas], self.storage_capacity ].min
    self.concrete = [ self.concrete + resources[:concrete], self.storage_capacity ].min
    self.suits = [ self.suits + resources[:suits], self.storage_capacity ].min
  end

  def subtract_resources!(resources)
    self.pizzas = self.pizzas - resources[:pizzas]
    self.concrete = self.concrete - resources[:concrete]
    self.suits = self.suits - resources[:suits]
  end

  def has_resources?(resources)
    self.pizzas >= resources[:pizzas] &&
        self.concrete >= resources[:concrete] &&
        self.suits >= resources[:suits]
  end

  def level building
    send building.key
  end

  def enqueued_count building
    if building_queue_items_count > 0
      building_queue_items.enqueued_count(building)
    else
      0
    end
  end

  def virtual_level building
    send(building.key) + enqueued_count(building)
  end

  def resource_gains time
    {
      pizzas: time * 0.01,
      concrete: time * 0.01,
      suits: time * 0.01
    }
  end
end
