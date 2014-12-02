module UnitQueueItemsHelper
  def link_to_recruit_start unit, number
    link_to number, villa_unit_queue_items_path(villa_id: current_villa.id, unit_id: unit.id, number: number),
                    method: :post, class: "btn btn-primary btn-sm"
  end

  def link_to_recruit_cancel queue_item
    link_to t('cancel'), villa_unit_queue_item_path(villa_id: current_villa.id, id: queue_item.id),
                         method: :delete, class: "btn btn-primary"
  end
end
