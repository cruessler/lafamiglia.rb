class MapController < ApplicationController
  MAP_RADIUS = 3

  def show
    x, y = params[:x].to_i, params[:y].to_i

    if x < 0
      x = 0
    end
    if x > LaFamiglia.config.max_x
      x = LaFamiglia.config.max_x
    end

    if y < 0
      y = 0
    end
    if y > LaFamiglia.config.max_y
      y = LaFamiglia.config.max_y
    end

    @min_x, @max_x = x - MAP_RADIUS, x + MAP_RADIUS
    @min_y, @max_y = y - MAP_RADIUS, y + MAP_RADIUS

    villas = Villa.in_rectangle(@min_x, @max_x, @min_y, @max_y).includes(:player).load

    @villas = Array.new(@max_y - @min_y + 1) { Array.new(@max_x - @min_x + 1) }

    villas.each do |v|
      @villas[v.y - @min_y][v.x - @min_x] = v
    end
  end
end
