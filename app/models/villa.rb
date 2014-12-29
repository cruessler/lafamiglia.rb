require_dependency 'lafamiglia'
require_dependency 'extensions/queue_extension'
require_dependency 'extensions/building_queue_extension'
require_dependency 'extensions/research_queue_extension'
require_dependency 'extensions/unit_queue_extension'

class Villa < ActiveRecord::Base
  belongs_to :player

  has_many :building_queue_items, -> { extending QueueExtension, BuildingQueueExtension }, dependent: :delete_all,
           after_add: ->(v, i) { v.building_queue_items_count = v.building_queue_items_count + 1 },
           after_remove: ->(v, i) { v.building_queue_items_count = v.building_queue_items_count - 1 }
  has_many :research_queue_items, -> { extending QueueExtension, ResearchQueueExtension }, dependent: :delete_all,
           after_add: ->(v, i) { v.research_queue_items_count = v.research_queue_items_count + 1 },
           after_remove: ->(v, i) { v.research_queue_items_count = v.research_queue_items_count - 1 }
  has_many :unit_queue_items, -> { extending UnitQueueExtension }, dependent: :delete_all,
           after_add: ->(v, i) { v.unit_queue_items_count = v.unit_queue_items_count + 1 },
           after_remove: ->(v, i) { v.unit_queue_items_count = v.unit_queue_items_count - 1 }

  has_many :outgoings,
           -> { includes(:target).order(:arrival) },
           class_name: 'Movement',
           foreign_key: 'origin_id'

  before_create :set_default_values

  after_update :save_unit_queue

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
    self.research_queue_items_count = 0
    self.unit_queue_items_count = 0

    self.storage_capacity = 100
    self.resource_1 = self.resource_2 = self.resource_3 = 0

    self.building_1 = 1
    self.building_2 = 0

    self.research_1 = 0

    self.supply = 100
    self.used_supply = 0
    self.unit_1 = 0
  end

  def save_unit_queue
    if unit_queue_items_count > 0
      if (first = unit_queue_items.first).changed?
        first.save(validate: false)
      end
    end
  end

  def process_until!(timestamp)
    finished_items = []

    if building_queue_items_count > 0
      finished_items.concat building_queue_items.finished_until(timestamp)
    end

    if research_queue_items_count > 0
      finished_items.concat research_queue_items.finished_until(timestamp)
    end

    if unit_queue_items_count > 0
      finished_items.concat unit_queue_items.finished_until(timestamp)
    end

    if finished_items.length > 0
      finished_items.sort_by! { |i| i.completion_time }

      transaction do
        finished_items.each do |i|
          process_virtually_until! i.completion_time

          case i
          when BuildingQueueItem
            increment(i.building.key)
            building_queue_items.destroy i
          when ResearchQueueItem
            increment(i.research.key)
            research_queue_items.destroy i
          when UnitQueueItem
            unit_queue_items.destroy i
          end
        end

        save(validate: false)
      end
    end

    process_virtually_until! timestamp
  end

  def process_virtually_until! timestamp
    time_diff = timestamp - self.last_processed

    if time_diff != 0
      add_resources!(resource_gains time_diff)

      if unit_queue_items_count > 0
        add_units!(unit_queue_items.first.recruit_units_between!(self.last_processed, timestamp))
      end
    end

    self.last_processed = timestamp
  end

  def add_resources!(resources)
    self.resource_1 = [ self.resource_1 + resources[:resource_1], self.storage_capacity ].min
    self.resource_2 = [ self.resource_2 + resources[:resource_2], self.storage_capacity ].min
    self.resource_3 = [ self.resource_3 + resources[:resource_3], self.storage_capacity ].min
  end

  def subtract_resources!(resources)
    self.resource_1 = self.resource_1 - resources[:resource_1]
    self.resource_2 = self.resource_2 - resources[:resource_2]
    self.resource_3 = self.resource_3 - resources[:resource_3]
  end

  def has_resources?(resources)
    self.resource_1 >= resources[:resource_1] &&
        self.resource_2 >= resources[:resource_2] &&
        self.resource_3 >= resources[:resource_3]
  end

  def add_units!(units)
    units.each_pair do |key, number|
      write_attribute(key, read_attribute(key) + number)
    end
  end

  def subtract_units!(units)
    units.each_pair do |key, number|
      write_attribute(key, read_attribute(key) - number)
    end
  end

  def has_supply?(supply)
    self.used_supply + supply <= self.supply
  end

  def level building_or_research
    send building_or_research.key
  end

  def enqueued_count building
    if building_queue_items_count > 0
      building_queue_items.enqueued_count(building)
    else
      0
    end
  end

  def virtual_building_level building
    send(building.key) + enqueued_count(building)
  end

  def enqueued_researches_count research
    if research_queue_items_count > 0
      research_queue_items.enqueued_count(research)
    else
      0
    end
  end

  def virtual_research_level research
    send(research.key) + enqueued_researches_count(research)
  end

  def unit_number unit
    send unit.key
  end

  def resource_gains time
    {
      resource_1: time * 0.01,
      resource_2: time * 0.01,
      resource_3: time * 0.01
    }
  end
end
