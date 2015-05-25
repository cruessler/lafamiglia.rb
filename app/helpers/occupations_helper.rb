module OccupationsHelper
  def link_to_occupation_cancel occupation
    link_to t('cancel'), occupation_url(occupation),
                         method: :delete, class: "btn btn-primary"
  end
end
