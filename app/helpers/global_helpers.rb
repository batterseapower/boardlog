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

    def link_to_snapshot(snapshot)
      link_to Boardlog::DateTime.unparse(snapshot.taken_at), url(:whiteboard_snapshot, snapshot.whiteboard, snapshot)
    end

  end
end
