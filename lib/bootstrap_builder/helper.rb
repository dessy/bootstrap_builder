module BootstrapBuilder::Helper
  
  def bootstrap_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    options.merge!(:builder => BootstrapBuilder::Builder)
    (options[:html] ||= { }).merge!(:class => "#{options[:html][:class]} formatted")
    form_for(record_or_name_or_array, *(args << options), &proc)
  end
  
end