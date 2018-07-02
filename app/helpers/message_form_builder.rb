class MessageFormBuilder < SimpleForm::FormBuilder
  include ActionView::Helpers::TagHelper

  def players(attribute_name)
    html_options = {
      class: "player-select",
      data: {
        name: "#{object_name}[#{attribute_name.to_s.singularize}_ids]",
        players: @object.send(attribute_name).to_json(only: [:id, :name])
      }
    }

    tag.div html_options
  end
end
