class PluginSerializer < ActiveModel::Serializer
  attributes :url, :id

  def id
    url
  end

end
