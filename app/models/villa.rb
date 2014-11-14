require_dependency 'lafamiglia'

class Villa < ActiveRecord::Base
  belongs_to :player

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
end
