module Boardlog
  # This mixin obtains the whiteboard that this resource is a child of, and
  # makes sure that it is valid before every request
  module WhiteboardChildResource
    def self.included(base)
      base.class_eval('before :setup_whiteboard')
    end
    
    private
    
      def setup_whiteboard
        @whiteboard = Whiteboard.get(params[:whiteboard_id])
        raise Merb::ControllerExceptions::NotFound unless @whiteboard
      end
  end
  
  # This mixin just provides delegation to the check methods in GlobalHelper
  # for controllers with a @whiteboard instance variable
  module HasWhiteboardHelper
    def check_user_owns_whiteboard
      check_user_owns_this_whiteboard @whiteboard
    end

    def user_owns_whiteboard?
      user_owns_this_whiteboard? @whiteboard
    end
  end
end