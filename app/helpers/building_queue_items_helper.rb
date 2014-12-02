module BuildingQueueItemsHelper
  def link_to_build_start building
    level = current_villa.virtual_building_level building

    if level < building.maxlevel
      if level > 0
        title = t('upgrade')
      else
        title = ('build')
      end

      link_to title, villa_building_queue_items_path(villa_id: current_villa.id, building_id: building.id),
                     method: :post, class: "btn btn-primary"
    else
      link_to t('maxlevel_reached'), '#', class: "btn btn-primary disabled"
    end
  end

  def link_to_build_cancel queue_item
    link_to t('cancel'), villa_building_queue_item_path(villa_id: current_villa.id, id: queue_item.id),
                         method: :delete, class: "btn btn-primary"
  end
end
