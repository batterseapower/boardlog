module Merb
  module GlobalHelpers

    def check_user_owns_this_whiteboard(whiteboard)
      raise WhiteboardsCore::NotWhiteboardOwner unless whiteboard.owners.include? session.user
    end

  end
end
