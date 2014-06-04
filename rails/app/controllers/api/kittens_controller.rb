class Api::KittensController < ApplicationController

  def index
    render json: Kitten.all
  end

  def show
    render json: Kitten.find(params[:id])
  end

end
