class PlayersInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    @builder.multi_selector_field(attribute_name, :player, input_html_options)
  end
end
