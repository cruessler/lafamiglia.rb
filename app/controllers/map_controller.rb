class MapController < ApplicationController
  MAP_RADIUS = 3

  def show
    x, y = params[:x].to_i, params[:y].to_i

    if x < 0
      x = 0
    end
    if x > LaFamiglia.max_x
      x = LaFamiglia.max_x
    end

    if y < 0
      y = 0
    end
    if y > LaFamiglia.max_y
      y = LaFamiglia.max_y
    end

    min_x, max_x = x - MAP_RADIUS, x + MAP_RADIUS
    min_y, max_y = y - MAP_RADIUS, y + MAP_RADIUS

    villas = Villa.where([ 'x BETWEEN ? AND ? AND y BETWEEN ? AND ?', min_x, max_x, min_y, max_y ]).load

    @villas = Array.new(max_y - min_y + 1) { Array.new(max_x - min_x + 1) }

    villas.each do |v|
      @villas[v.y - min_y][v.x - min_x] = v
    end
  end
end