require 'ftools'
require 'gd2'

include GD2

module Boardlog
  class ImageStore
    
    def self.store_image(recieved_file, original_file_name)
      # Find appropriate extension - this is all we use the original name for
      extension = File.extname(original_file_name)
      
      # Create host directory
      web_relative_base_path = 'uploads/'
      script_relative_base_path = Merb.root / 'public' / 'uploads'
      File.makedirs(script_relative_base_path)
      
      # Find an acceptable, unique, image file name by searching for an unused one
      # in the directory in question
      iteration = 0
      rescues_necessary = 0
      while iteration += 1
        # Construct the filename we'll try this time
        filename = Time.now.strftime("%Y%m%d-%H%M%S-#{iteration}#{extension}")
        path = script_relative_base_path / filename
        
        # Try to avoid obviously bad paths
        next if File.exist?(path.to_s)
        
        # Open the file. Possible race condition: file was created
        # between the if statement and the point we open the file.
        try
          # Create an empty file with this name to claim it
          File.open(path, File::EXCL | File.WRONLY | File.CREAT) { |f| nil }
        rescue SystemCallError => error
          rescues_necessary += 1
          raise error if rescues_necessary > 3
        else
          # There was no exception, so we have claimed the path!
          
          # Just copy the recieved file into position
          #FileUtils.mv recieved_file.path, path.to_s
          
          # Alternatively, resize the recieved file into position
          # (ImageMagick is a pain to get working on OS X!)
          #file = Magick::Image.read(recieved_file.path).first
          #file.resize_to_fit!(800, 600)
          #file.write(path.to_s)
          
          # Alternatively, resize the recieved file into position
          image = Image.import(recieved_file.path)
          image.resize! 800, 600
          image.export(path.to_s)
        end
      end
      
      # Construct a URL relative to HTTPROOT for the caller
      web_relative_base_path + filename
    end

  end
end