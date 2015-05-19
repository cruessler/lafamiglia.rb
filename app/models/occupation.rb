class Occupation < ActiveRecord::Base
  include LaFamiglia::Units::Accessors

  belongs_to :occupied_villa, class_name: 'Villa'
  belongs_to :occupying_villa, class_name: 'Villa'

  after_create :set_is_occupied_for_villa
  after_destroy :unset_is_occupied_for_villa

  def set_is_occupied_for_villa
    occupied_villa.update_attribute :is_occupied, true
  end

  def unset_is_occupied_for_villa
    occupied_villa.update_attribute :is_occupied, false
  end
end
