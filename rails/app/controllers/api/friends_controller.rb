class Api::FriendsController < ApplicationController
  include PluginByRequestSupportMixin

  def index
    render json: Friend.all,  each_serializer: FriendSerializer
  end

  def show
    render json: Friend.find( params[:id] ), serializer: FriendSerializer
  end

  # Forward the request to each of our friends (and to ourselves)
  def plugin_dispatch
    render :json => plugin.all_dispatch( request_info )
  end

end
