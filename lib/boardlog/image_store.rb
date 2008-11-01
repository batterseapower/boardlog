require 'ftools'

module Boardlog
  class ImageStore
    
    def self.store_image(what)
      # Find an acceptable, unique, image file name by searching for an unused one
      # in the directory in question
      iteration = 0
      while iteration + 1
        filename = Time.now.strftime("%Y%m%d-%H%M%S-#{iteration}")
        path = "public/uploads/#{filename}"
        next if File.exist?(path)
      end
      
      File.makedirs()
    end

  end
end