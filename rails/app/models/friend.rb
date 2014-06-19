class Friend < ActiveSparql::Simple
  @class_uri = 'http://ddcat.edcat.tenforce.com/Friend'

  validates_presence_of :url

  # Indicates that the friend with url URL joined the peer group
  def self.join( url)
    Friend.new( url: url ).save
  end

  # Indicates that the friend with url URL left the peer group
  def self.leave( url )
    Friend.find( url ).destroy
  end

  def self.register_at_peer_cnnctr
    # destroy the current friends
    Friend.all.map &:destroy
    # call the peer_cnnctr and add all current friends
    peer_cnnctr_uri = URI "#{Cfg.peer_cnnctr_url}peer_groups/#{Cfg.peer_cnnctr_peer_group}/peers.json"
    my_cnnctr_info = { "peer[contact_point]" => Cfg.own_contact_point, "peer[shared_contact_url]" => Cfg.shared_contact_url }
    result = Net::HTTP.post_form( peer_cnnctr_uri , my_cnnctr_info )
    json = JSON.parse result.body
    json["peers"].each do |contact_point|
      # add our freshly joined peers
      Friend.new( url: contact_point ).save
    end
  end

  def self.object_graph
    Cfg.friend_graph
  end

end
