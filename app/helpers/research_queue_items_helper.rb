module ResearchQueueItemsHelper
  def link_to_research_start research
    level = current_villa.virtual_research_level research

    if research.requirements_met? current_villa
      if level < research.maxlevel
        if level > 0
          title = t('upgrade')
        else
          title = ('research')
        end

        link_to title, villa_research_queue_items_path(villa_id: current_villa.id, research_id: research.id),
                       method: :post, class: "btn btn-primary"
      else
        link_to t('maxlevel_reached'), '#', class: "btn btn-primary disabled"
      end
    else
      link_to t('requirements_not_met'), '#', class: "btn btn-primary disabled"
    end
  end

  def link_to_research_cancel queue_item
    link_to t('cancel'), villa_research_queue_item_path(villa_id: current_villa.id, id: queue_item.id),
                         method: :delete, class: "btn btn-primary"
  end
end
