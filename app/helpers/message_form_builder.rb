class MessageFormBuilder < SimpleForm::FormBuilder
  def multi_selector_field(attribute_name, object_type, input_html_options)
    html_options = { class: "#{object_type}-select",
                     "data-name" => "#{object_name}[#{attribute_name.to_s.singularize}_ids]",
                     "data-objects" => @object.send(attribute_name).to_json }

    @template.render partial: "inputs/#{object_type}_select",
                     locals: { input_html_options: input_html_options.merge(html_options) }
  end

  def players(attribute_name)
    input attribute_name, as: :players
  end
end
