require 'exifr'
require 'gd2'

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
    
    def self.resize_to_constraints(width, height, from_filename, to_filename, options)
      desired_aspect_ratio = width.to_f / height
      GD2::Image.import(from_filename, options) do |image|
        observed_aspect_ratio = image.width.to_f / image.height
        
        final_width, final_height = if observed_aspect_ratio > desired_aspect_ratio then
          # Actual image is comparatively FATTER than the target
          [width, width / observed_aspect_ratio]
        else
          # Actual image is comparatively THINNER than the target
          [height * observed_aspect_ratio, height]
        end
        
        image.resize!(final_width, final_height, :resample => true)
        image.export(to_filename)
      end
    end
  end
end