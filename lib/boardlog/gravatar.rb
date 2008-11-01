require 'digest/md5'

# Returns a Gravatar URL associated with the email parameter.
# Thanks to Douglas F Shearer (http://douglasfshearer.com/blog/gravatar-for-ruby-and-ruby-on-rails)
def gravatar_url_for_email(email, gravatar_options={})

  # Default highest rating.
  # Rating can be one of G, PG, R or X.
  # If set to nil, the Gravatar default of X will be used.
  gravatar_options[:rating] ||= nil

  # Default size of the image.
  # If set to nil, the Gravatar default size of 80px will be used.
  gravatar_options[:size] ||= nil 

  # Default image url to be used when no gravatar is found
  # or when an image exceeds the rating parameter.
  gravatar_options[:default] ||= nil

  # Build the Gravatar url.
  grav_url = 'http://www.gravatar.com/avatar.php?'
  grav_url << "gravatar_id=#{Digest::MD5.new.update(email)}" 
  grav_url << "&rating=#{gravatar_options[:rating]}" if gravatar_options[:rating]
  grav_url << "&size=#{gravatar_options[:size]}" if gravatar_options[:size]
  grav_url << "&default=#{gravatar_options[:default]}" if gravatar_options[:default]
  return grav_url
end