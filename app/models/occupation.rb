class Occupation < ActiveRecord::Base
  include LaFamiglia::Units::Accessors

  belongs_to :occupied_villa, class_name: 'Villa'
  belongs_to :occupying_villa, class_name: 'Villa'
end
