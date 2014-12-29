module MovementsHelper
  def link_to_movement_cancel movement
    link_to t('cancel'), movement_url(movement),
                         method: :delete, class: "btn btn-primary"
  end
end
