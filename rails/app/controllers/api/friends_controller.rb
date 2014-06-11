class Api::FriendsController < ApplicationController

  def index
    render json: Friend.all,  each_serializer: FriendSerializer
  end

  def show
    render json: Friend.find( params[:id] ), serializer: FriendSerializer
  end

end
