module Boardlog
  class Format
    def self.alternatives_list(list)
      list.length == 1 ? list[0] : list[0..-2].join(', ') + ' or ' + list[-1]
    end
    
    def self.date_time(date_time)
      # Time formatting similar to "31 October 2008, 18:19pm"
      # See http://snippets.dzone.com/posts/show/2255 for format codes
      date_time.strftime("%e %B %Y, %I:%M%P")
    end
  end
end