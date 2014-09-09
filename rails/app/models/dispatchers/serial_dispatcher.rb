class Dispatchers::SerialDispatcher < Dispatcher

  # The default behaviour of Dispatcher is to handle each friend in series
  def dispatch_friend( friend )
    begin
      HTTParty.get("#{friend.url}#{plugin.request.path}").path
    rescue
      ""
    end
  end

  # The default behaviour of Dispatcher is to handle each kitten in series
  def dispatch_kitten( kitten )
    begin
      HTTParty.get("#{kitten.url}#{plugin.request.path}").path
    rescue
      ""
    end
  end

end
