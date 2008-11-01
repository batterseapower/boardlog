# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
#
# Don't forget that by default the salted_user mixin is used from merb-more
# You'll need to setup your db as per the salted_user mixin, and you'll need
# To use :password, and :password_confirmation when creating a user
#
# see merb/merb-auth/setup.rb to see how to disable the salted_user mixin
# 
# You will need to setup your database and create a user.
class User
  include DataMapper::Resource
  
  has n, :owned_whiteboards, :through => Resource, :class_name => 'Whiteboard'
  
  property :id, Serial
  property :name, String, :length => (1..50)
  property :email, String, :length => (1..80)
  
  validates_format :email, :as => :email_address
  
  def gravatar_url(size)
    gravatar_url_for_email(email, :rating => 'PG', :size => size)
  end
  
end
