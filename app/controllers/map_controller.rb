class MapController < ApplicationController
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

    min_x, max_x = x - LaFamiglia.config.map_radius, x + LaFamiglia.config.map_radius
    min_y, max_y = y - LaFamiglia.config.map_radius, y + LaFamiglia.config.map_radius

    @villas =
      Villa
        .in_rectangle(min_x, max_x, min_y, max_y)
        .includes(:player)
        .load

    @dimensions = { min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y }

    @authenticity_token =
      form_authenticity_token form_options: {
        action: "/villas/#{current_villa.id}/movements", method: "POST"
      }
  end
end
