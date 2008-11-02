require 'exifr'

module Boardlog
  class Images
    def self.guess_image_date_time(filename)
      begin
        time = EXIFR::JPEG.new(filename).date_time_original
        # If the time data in the EXIF doesn't match an expected format we get back a string..
        time.class == Time.class ? time : nil
      rescue String, Symbol, RuntimeError
        # For some reason, exifr reports errors using strings (e.g. 'malformed JPEG'), which
        # turn into RuntimeErrors. I'm not happy about catching of them, but there you go
        nil
      end
    end
  end
end