module Boardlog
  class DateTime
    
    def self.unparse(date_time)
      # Time formatting similar to "31 October 2008, 18:19pm"
      # See http://snippets.dzone.com/posts/show/2255 for format codes
      date_time.strftime("%e %B %Y, %I:%M%P")
    end

    def self.parse(string)
      # Use the built in heuristic magic to work out dates
      DateTime.parse(string)
    end

  end
end