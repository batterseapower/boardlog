module Boardlog
  class NotWhiteboardOwner < Merb::ControllerExceptions::Unauthorized; end
  class NotCorrectUser < Merb::ControllerExceptions::Unauthorized; end
end