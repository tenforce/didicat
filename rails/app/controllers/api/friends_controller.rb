class Api::FriendsController < ApplicationController
  def index
    render json: Friend.all
  end

  def show
    render json: Friend.find( params[:id] )
  end
end
