require 'ftools'
require 'gd2'

include GD2

module Boardlog
  class ImageStore
    
    def self.store_image(options)
      # Extract options
      directory = options[:directory]
      image = options[:image]
      raise ArgumentError, 'Missing required option :directory' if directory.nil?
      raise ArgumentError, 'Missing required option :image' if image.nil?
      
      # Find appropriate extension - this is all we use the original name for
      extension = File.extname(image[:filename])
      
      # Create host directory
      web_relative_base_path = '/uploads' / directory
      script_relative_base_path = Merb.root / 'public' / 'uploads' / directory
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
      
      # Could also guess the format using the MIME type, but that's more work!
      guessed_format = extension[1..-1].downcase
      
      # Resize the image we were supplied with and save that in the final location
      Image.import(image[:tempfile].path, :format => guessed_format) do |image|
        image.resize!(800, 600, :resample => true)
        image.export(path)
      end
      
      # Construct a URL relative to HTTPROOT for the caller
      web_relative_base_path / filename
    end

  end
end