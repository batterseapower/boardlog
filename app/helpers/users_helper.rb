module Merb
  module UserHelper

    def check_user_is_user
      raise Boardlog::NotCorrectUser unless user_is_user?
    end

    def user_is_user?
      @user == session.user
    end

  end
end