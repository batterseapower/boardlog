class Snapshot
  include DataMapper::Resource
  
  belongs_to :whiteboard
  
  property :id, Serial
  property :taken_at, DateTime, :nullable => false
  property :image_url, String, :nullable => false
  property :body, Text, :nullable => false

  def body_html
    # We don't bother caching this in the database.. for now
    Boardlog::Sanitize.sanitize_markdown(body)
  end

end
