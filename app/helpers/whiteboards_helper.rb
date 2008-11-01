module Merb
  module WhiteboardsHelper

    def check_user_owns_whiteboard
      check_user_owns_this_whiteboard @whiteboard
    end

  end
end