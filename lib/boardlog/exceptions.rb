module Boardlog
  class NotWhiteboardOwner < Merb::ControllerExceptions::Unauthorized; end
  class NotCorrectUser < Merb::ControllerExceptions::Unauthorized; end
  
  class UnacceptableImageFormat < Merb::ControllerExceptions::NotAcceptable
    attr_reader :format
    
    def initialize(format)
      @format = format
    end
  end
end