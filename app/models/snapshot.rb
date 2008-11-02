class Snapshot
  include DataMapper::Resource
  
  belongs_to :whiteboard
  
  property :id, Serial
  property :taken_at, DateTime, :nullable => false
  property :image_url, String, :nullable => false, :length => (1..512)
  property :body, Text, :nullable => false
  property :public, Boolean, :nullable => false

  def previous
    whiteboard.snapshots.first(:taken_at.lt => taken_at)
  end
  
  def next
    whiteboard.snapshots.first(:taken_at.gt => taken_at)
  end

  def body_html
    # We don't bother caching this in the database.. for now
    Boardlog::Sanitize.sanitize_markdown(body)
  end

end
