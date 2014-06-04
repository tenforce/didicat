class PeerSerializer < ActiveModel::Serializer
  attributes :id, :api_url, :peer_url
end
