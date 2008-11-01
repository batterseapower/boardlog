require 'ftools'

module WhiteboardsCore
  class ImageStore
    
    def self.store_image(what)
      UPLOAD_DIRECTORY = "public/uploads/"
      
      # Find an acceptable, unique, image file name by searching for an unused one
      # in the directory in question
      iteration = 0
      while iteration + 1
        filename = Time.now.strftime("%Y%m%d-%H%M%S-#{iteration}")
        path = "#{UPLOAD_DIRECTORY}#{filename}"
        next if File.exist?(path)
      end
      
      File.makedirs()
    end

  end
end