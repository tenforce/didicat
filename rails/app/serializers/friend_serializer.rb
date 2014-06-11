class FriendSerializer < ActiveModel::Serializer
  attributes :id, :url

  def url
    object.url.to_s
  end

  def id
    url
  end
end
