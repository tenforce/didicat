class Dispatchers::SerialDispatcher < Dispatcher

  # The default behaviour of Dispatcher is to handle each friend in series
  def dispatch_friend( friend )
    uri = URI "#{friend.url}/"
    Net::HTTP.get( uri.host , uri.path ) # get is overly eager
  end

  # The default behaviour of Dispatcher is to handle each kitten in series
  def dispatch_kitten( kitten )
    uri = URI "#{kitten.url}/"
    Net::HTTP.get( uri.host , uri.path ) # get is overly eager
  end

end
