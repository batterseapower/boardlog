require 'ftools'
require 'gd2'

include GD2

module Boardlog
  # TODO: generate thumbnails as well?
  class ImageStore
    
    def initialize(directory)
      @absolute_base = Merb.root / 'public' / 'uploads' / directory
      @web_relative_base = '/uploads' / directory
      
      # Create host directory
      File.makedirs(@absolute_base)
    end
    
    def store_image(image)
      # Find an appropriate extension - this is all we use the original name for
      extension = File.extname(image[:filename]).downcase
      
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
        
        path = @absolute_base / filename
        
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
      
      # Could also guess the format using the MIME type, but that's more work!
      guessed_format = extension[1..-1]
      
      # Resize the image we were supplied with and save that in the final location
      Image.import(image[:tempfile].path, :format => guessed_format) do |image|
        image.resize!(800, 600, :resample => true)
        image.export(path)
      end
      
      # Construct a URL relative to HTTPROOT for the caller
      @web_relative_base / filename
    end

    def try_delete_image(image_url)
      # Take apart the URL in a way that ensures we only get a plain filename to delete, and
      # that will only happen if the URL was generated by store_image
      return if image_url[0..@web_relative_base.length - 1] != @web_relative_base
      match = image_url[@web_relative_base.length..-1].match(/^[0-9\-]+\.?[A-Za-z0-9]*$/)
      return if !match
      
      # Delete the file. This is safe because the match cannot contain e.g. ..
      File.delete(@absolute_base / match.to_s)
    end
    
    private
    
      # Modified from http://www.travisonrails.com/2007/06/07/Generate-random-text-with-Ruby
      def generate_filename(length=32)
        chars = 'abcdefghijklmnpoqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
        password = ''
        length.times { |i| password << chars[rand(chars.length)] }
        password
      end

  end
end