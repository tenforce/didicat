class Api::KittensController < ApplicationController
  include PluginByRequestSupportMixin

  def index
    render json: Kitten.all
  end

  def show
    render json: Kitten.find(params[:id])
  end

  def create
    kitten = Kitten.new kitten_params

    begin kitten.save!
      render json: kitten
    rescue
      render json: kitten.errors, status: :unprocessable_entity
    end

  end

  def update
    kitten = Kitten.find params[:id]

    begin kitten.update! kitten_params
      render json: kitten
    rescue
      render json: kitten, status: :unprocessable_entity
    end
  end

  # forward the request to each of our kittens
  def plugin_dispatch
    render :json => plugin.kitten_dispatch( request_info )
  end

  def destroy
    kitten = Kitten.find params[:id]
    kitten.destroy
    head :no_content
  end

private

  def kitten_params
    params.require(:kitten).permit(:url)
  end

end
