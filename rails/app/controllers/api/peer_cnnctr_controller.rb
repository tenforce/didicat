class Api::PeerCnnctrController < ApplicationController

  def update
    Friend.join params[:joined] if params[:joined]
    Friend.leave params[:left] if params[:left]

    render json: { update: "ok" }
  end

end
