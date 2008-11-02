module Merb
  module GlobalHelpers

    def check_user_owns_this_whiteboard(whiteboard)
      raise WhiteboardsCore::NotWhiteboardOwner unless user_owns_this_whiteboard?(whiteboard)
    end
    
    def user_owns_this_whiteboard?(whiteboard)
      whiteboard.owners.include? session.user
    end
    
    def link_to_user(user)
      link_to user.name, resource(user)
    end

  end
end
