module BootstrapBuilder
  class Builder < ActionView::Helpers::FormBuilder
    
    %w(text_field password_field text_area file_field datetime_select date_select time_zone_select).each do |field_name|
      define_method field_name do |method, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        render_field(field_name, method, options) { super(method, options) } 
      end
    end

    def select(method, choices, options = {}, html_options = {})
      render_field('select', method, options) { super(method, choices, options, html_options) } 
    end

    def hidden_field(method, options = {}, html_options = {})
      super(method, options)
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      if options[:values].present?
        values = options[:values].collect do |key, val|

          {
            :field => super(method, options.merge({:name => "#{object_name}[#{method}][]"}), val, nil),
            :label_text => key,
            :label_for => "#{object_name}_#{method}_#{val.to_s.gsub(' ', '_').underscore}"
          }
        end
        @template.render(:partial => "#{BootstrapBuilder.config.template_folder}/check_box", :locals  => {
          :builder => self,
          :method => method,
          :values => values,
          :label_text => label_text(method, options.delete(:label)),
          :error_messages => error_messages_for(method)
        })
      else
        render_field('check_box', method, options) do
          super(method, options, checked_value, unchecked_value)
        end
      end
    end

    def radio_button(method, tag_value, options = {})
      case tag_value
        when Array
          choices = tag_value.collect do |choice|
            if !choice.is_a?(Array)
              choice = [choice, choice]
            elsif choice.length == 1
              choice << choice[0]
            end
            {
              :field => super(method, choice[1], options),
              :label => choice[0],
              :label_for => "#{object_name}_#{method}_#{choice[1].to_s.gsub(' ', '_').underscore}"
            }
          end
        else
          choices = [{
            :field => super(method, tag_value),
            :label => tag_value,
            :label_for => "#{object_name}_#{method}_#{tag_value.to_s.gsub(' ', '_').underscore}"
          }]
      end
      
      @template.render(:partial => "#{BootstrapBuilder.config.template_folder}/radio_button", :locals  => {
        :builder => self,
        :method => method,
        :label_text => label_text(method, options.delete(:label)),
        :choices => choices,
        :required => options.delete(:required),
        :before_text => @template.raw(options.delete(:before_text)),
        :after_text => @template.raw(options.delete(:after_text)),
        :help_block => @template.raw(options.delete(:help_block)),
        :error_messages => error_messages_for(method)
      })
    end

    # f.submit 'Log In', :change_to_text => 'Logging you in ...'
    def submit(value, options={}, &block)
      after_text = @template.capture(&block) if block_given?
      
      # Add specific bootstrap class
      options[:class] ||= ''
      options[:class] += ' btn'
      unless options[:class] =~ /btn-/
        options[:class] += ' btn-primary' 
      end

      # Set the script to change the text
      if change_to_text = options.delete(:change_to_text)
        options[:onclick] ||= ''
        options[:onclick] = "$(this).closest('.actions').hide();$(this).closest('.actions').after($('<div class=actions>#{change_to_text}</div>'))"
      end

      @template.render(:partial => "#{BootstrapBuilder.config.template_folder}/submit", :locals  => {
        :builder => self,
        :field => super(value, options),
        :after_text => after_text,
        :change_to_text => change_to_text
      })
    end

    # generic container for all things form
    def element(label = '&nbsp;', value = '', type = 'text_field', &block)
      value += @template.capture(&block) if block_given?
      %{
        <div class='form_element #{type}'>
          <div class='label'>
            #{label}
          </div>
          <div class='value'>
            #{value}
          </div>
        </div>
      }.html_safe
    end

    def error_messages
      if object && !object.errors.empty?
        message = object.errors[:base].present? ? object.errors[:base]: 'There were some problems submitting this form. Please correct all the highlighted fields and try again'
        @template.content_tag(:div, message, :class => 'form_error')
      end
    end

    def error_messages_for(method)
      if (object and object.respond_to?(:errors) and errors = object.errors[method] and !errors.empty?)
        errors.is_a?(Array) ? errors.first : errors
      end
    end

    def fields_for(record_or_name_or_array, *args, &block)
      options = args.extract_options!
      options.merge!(:builder => BootstrapBuilder::Builder)
      super(record_or_name_or_array, *(args << options), &block)
    end

    
  protected
    
    # Main rendering method
    def render_field(field_name, method, options={}, &block)
      case field_name
      when 'check_box'
        template = field_name
      else
        template = 'default_field'
      end
      @template.render(:partial => "#{BootstrapBuilder.config.template_folder}/#{template}", :locals  => {
        :builder => self,
        :method => method,
        :field_name => field_name,
        :field => @template.capture(&block),
        :label_text => label_text(method, options.delete(:label)),
        :required => options.delete(:required),
        :prepend => @template.raw(options.delete(:prepend)),
        :append => @template.raw(options.delete(:append)),
        :help_block => @template.raw(options.delete(:help_block)),
        :error_messages => error_messages_for(method)
      })
    end

    def label_text(method, text = nil)
      text.nil? ? method.to_s.titleize.capitalize : @template.raw(text)
    end
    
  end
end