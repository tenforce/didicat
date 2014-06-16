class Api::PeerCnnctrController < ApplicationController

  def update
    Friend.joined params[:joined] if params[:joined]
    Friend.left params[:left] if params[:left]

    render json: { update: "ok" }
  end

end
