module Merb
  module Helpers
    module Form
      radio_button_method = instance_method(:radio_button)
      define_method :radio_button do |*args|
        # Find the options hash in the arguments, if any
        hash_idx = args.length - 1
        options = hash_idx >= 0 && args[hash_idx].class == Hash ? args[hash_idx] : nil
        
        # Workaround for ticket #178 (http://merb.lighthouseapp.com/projects/7588/tickets/178-radio-button-checked-enhancement)
        # Remove the "checked" item from the options when it's value is false
        options.delete(:checked) if options && !options[:checked]
        radio_button_method.bind(self).call(*args)
      end
    end
  end
end