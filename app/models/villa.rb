require_dependency 'extensions/queue_extension'
require_dependency 'extensions/building_queue_extension'
require_dependency 'extensions/research_queue_extension'
require_dependency 'extensions/unit_queue_extension'

class Villa < ActiveRecord::Base
  include LaFamiglia::Resources::Accessors
  include LaFamiglia::Buildings::Readers
  include LaFamiglia::Researches::Readers
  include LaFamiglia::Units::Accessors

  belongs_to :player

  has_many :building_queue_items, -> { extending QueueExtension, BuildingQueueExtension }, dependent: :delete_all,
           after_add: ->(v, i) { v.building_queue_items_count += 1 },
           after_remove: ->(v, i) { v.building_queue_items_count -= 1 }
  has_many :research_queue_items, -> { extending QueueExtension, ResearchQueueExtension }, dependent: :delete_all,
           after_add: ->(v, i) { v.research_queue_items_count += 1 },
           after_remove: ->(v, i) { v.research_queue_items_count -= 1 }
  has_many :unit_queue_items, -> { extending UnitQueueExtension }, dependent: :delete_all,
           after_add: ->(v, i) { v.unit_queue_items_count += 1 },
           after_remove: ->(v, i) { v.unit_queue_items_count -= 1 }
           # These hooks have to be used because Rails’ counter caching
           # only updates the database.

  has_many :outgoings,
           -> { includes(:target).order(:arrives_at) },
           class_name: 'Movement',
           foreign_key: 'origin_id'
  has_many :incomings,
           -> { includes(:origin).order(:arrives_at) },
           class_name: 'Movement',
           foreign_key: 'target_id'

  has_one :occupation, foreign_key: 'target_id'
  has_many :occupations, foreign_key: 'origin_id'

  before_create :set_default_values

  after_update :save_unit_queue

  def self.empty_coordinates(x_1 = 0, x_2 = LaFamiglia.config.max_x,
                             y_1 = 0, y_2 = LaFamiglia.config.max_y)
    x_range_length = x_2 - x_1
    y_range_length = y_2 - y_1
    max_villas_in_rectangle = x_range_length * y_range_length

    if Villa.in_rectangle(x_1, x_2, y_1, y_2).count < max_villas_in_rectangle
      if max_villas_in_rectangle == 1
        return [ x_1, y_1 ]
      end

      if x_range_length < y_range_length
        y_range_mean = y_1 + y_range_length / 2

        new_y_ranges = [ [ y_1, y_range_mean - 1 ],
                         [ y_range_mean, y_2 ] ].sort_by { rand }

        empty_coordinates(x_1, x_2, *new_y_ranges.first) or
          empty_coordinates(x_1, x_2, *new_y_ranges.last)
      else
        x_range_mean = x_1 + x_range_length / 2

        new_x_ranges = [ [ x_1, x_range_mean - 1 ],
                         [ x_range_mean, x_2 ] ].sort_by { rand }

        empty_coordinates(*new_x_ranges.first, y_1, y_2) or
          empty_coordinates(*new_x_ranges.last, y_1, y_2)
      end
    end
  end

  def self.in_rectangle x_1, x_2, y_1, y_2
    where [ 'x BETWEEN ? AND ? AND y BETWEEN ? AND ?',
            x_1, x_2, y_1, y_2 ]
  end

  def self.create_for player
    return nil unless (coordinates = empty_coordinates)

    transaction do
      new_villa = Villa.create(x: coordinates[0],
                  y: coordinates[1],
                  name: I18n.t('villa.default_name'),
                  player: player)

      player.recalc_points!

      new_villa
    end
  end

  def set_default_values
    self.processed_until = LaFamiglia.now
    self.is_occupied = false
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
    self.unit_2 = 0

    recalc_points
  end

  def save_unit_queue
    if unit_queue_items_count > 0
      if (first = unit_queue_items.first).changed?
        first.save(validate: false)
      end
    end
  end

  def recalc_points
    self.points = LaFamiglia.buildings.inject(0) do |sum, b|
      sum + b.points(level b)
    end
  end

  def process_until!(time)
    points_changed = false
    finished_items = []

    if building_queue_items_count > 0
      finished_items.concat building_queue_items.finished_until(time)
    end

    if research_queue_items_count > 0
      finished_items.concat research_queue_items.finished_until(time)
    end

    if unit_queue_items_count > 0
      finished_items.concat unit_queue_items.finished_until(time)
    end

    if finished_items.length > 0
      finished_items.sort_by! { |i| i.completed_at }

      transaction do
        finished_items.each do |i|
          process_virtually_until! i.completed_at

          case i
          when BuildingQueueItem
            increment(i.building.key)
            recalc_points
            points_changed = true
            building_queue_items.destroy i
          when ResearchQueueItem
            increment(i.research.key)
            research_queue_items.destroy i
          when UnitQueueItem
            unit_queue_items.destroy i
          end
        end

        save(validate: false)
        player.recalc_points! if points_changed
      end
    end

    process_virtually_until! time
  end

  # Processes resource gains and recruiting of units without saving
  # the results to the database.
  #
  # Relies on the fact that the difference between self.processed_until
  # and time makes sense for unit_queue_items.first.
  #
  # Must not be called more than once in a row as otherwise the amount
  # of units recruited would be incorrect due to unit_queue_items.first
  # not being saved in between.
  def process_virtually_until! time
    time_diff = time - self.processed_until

    if time_diff != 0
      add_resources!(resource_gains time_diff)

      if unit_queue_items_count > 0
        add_units!(unit_queue_items.first.recruit_units_between!(self.processed_until, time))
      end
    end

    self.processed_until = time
  end

  def add_resources!(resources)
    self.resource_1 = [ self.resource_1 + resources[:resource_1], self.storage_capacity ].min
    self.resource_2 = [ self.resource_2 + resources[:resource_2], self.storage_capacity ].min
    self.resource_3 = [ self.resource_3 + resources[:resource_3], self.storage_capacity ].min
  end

  def subtract_resources!(resources)
    self.resource_1 -= resources[:resource_1]
    self.resource_2 -= resources[:resource_2]
    self.resource_3 -= resources[:resource_3]
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

  def occupied?
    is_occupied
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

  def resource_gains time_diff
    {
      resource_1: time_diff * 0.01,
      resource_2: time_diff * 0.01,
      resource_3: time_diff * 0.01
    }
  end

  def to_s
    "#{name} (#{x}|#{y})"
  end
end
