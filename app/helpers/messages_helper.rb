module MessagesHelper
  def message_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: MessageFormBuilder)), &block)
  end
end
