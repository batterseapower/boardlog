module Merb
  module SnapshotsHelper

    def check_user_owns_whiteboard
      check_user_owns_this_whiteboard @whiteboard
    end

    def user_owns_whiteboard?
      user_owns_this_whiteboard? @whiteboard
    end

  end
end