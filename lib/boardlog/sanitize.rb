require 'bluecloth'
# Dubious to import this in a Merb project:
require 'action_controller'

module Boardlog
  class Sanitize
    
    def self.sanitize_markdown(markdown)
      sanitize_html(BlueCloth.new(markdown).to_html)
    end
    
    def self.sanitize_html(html)
      ::HTML::WhiteListSanitizer.new.sanitize(html, :tags => %w(b i ol ul li pre code tt p), :attributes => %w(id class style))
    end
  end
end
