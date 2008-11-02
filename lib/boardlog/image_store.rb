require 'ftools'
require 'gd2'

module Boardlog
  # TODO: generate thumbnails as well?
  class ImageStore
    
    URL_BASE = '' / 'uploads' / 'images'
    ABSOLUTE_PATH_BASE = Merb.root / 'public' / 'uploads' / 'images'
    ACCEPTABLE_FORMATS = ["jpg", "png", "gif"]
    
    def self.store_image(image)
      # Create host directory
      File.makedirs(ABSOLUTE_PATH_BASE)
      
      # Find an appropriate extension - this is all we use the original name for
      # Could also guess the format using the MIME type, but that's more work!
      extension = File.extname(image[:filename]).downcase
      guessed_format = extension[1..-1]
      
      # Check the format is acceptable
      if !ACCEPTABLE_FORMATS.include?(guessed_format) then
        raise UnacceptableImageFormat.new(guessed_format)
      end
      
      # Find an acceptable, unique, image file name by searching for an unused one
      # in the directory in question
      iteration = 0
      rescues_necessary = 0
      while iteration += 1
        # Construct the filename we'll try this time:
        filename = "#{generate_filename}#{extension}"
        # We used to use this algorithm to generate file names but the results
        # are insufficiently random to give privacy:
        #filename = Time.now.strftime("%Y%m%d-%H%M%S-#{iteration}#{extension}")
        
        path = ABSOLUTE_PATH_BASE / filename
        
        # Try to avoid obviously bad paths
        next if File.exist?(path.to_s)
        
        # Open the file. Possible race condition: file was created
        # between the if statement and the point we open the file.
        begin
          # Create an empty file with this name to claim it
          File.open(path, File::EXCL | File::WRONLY | File::CREAT) { |f| }
        rescue SystemCallError => error
          rescues_necessary += 1
          raise error if rescues_necessary > 3
        else
          # There was no exception, so we have claimed the path!
          break
        end
      end
      
      # Resize the image we were supplied with and save that in the final location
      GD2::Image.import(image[:tempfile].path, :format => guessed_format) do |image|
        image.resize!(BOARD_IMAGE_WIDTH, BOARD_IMAGE_HEIGHT, :resample => true)
        image.export(path)
      end
      
      # Construct a URL relative to HTTPROOT for the caller
      filename
    end
    
    private
    
      # Modified from http://www.travisonrails.com/2007/06/07/Generate-random-text-with-Ruby
      def self.generate_filename(length=32)
        chars = 'abcdefghijklmnpoqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
        password = ''
        length.times { |i| password << chars[rand(chars.length)] }
        password
      end

  end
end