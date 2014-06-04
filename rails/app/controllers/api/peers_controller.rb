class Api::PeersController < ApplicationController
  def index
    render json: Peer.all
  end

  def show
    render json: Peer.find(params[:id])
  end
end
