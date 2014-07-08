class PluginSerializer < ActiveModel::Serializer
  attributes :url, :id, :request_method, :request_regex

  def id
    url
  end

  def request_method
    object.verb.to_s
  end

  def request_regex
    object.regex.to_s
  end

end
