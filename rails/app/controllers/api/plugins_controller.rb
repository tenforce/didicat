class Api::PluginsController < ApplicationController
  before_action :set_plugin, only: [:show, :edit, :update, :destroy]

  def index
    render json: { plugins: Plugin.all.collect do |p| { url: p.url.to_s, id: p.url.to_s } end }
    #, each_serializer: PluginSerializer

  end

  def show
    render json: Plugin
  end

  def create
    plugin = Plugin.new plugin_params

    if plugin.save
      render json: plugin
    else
      render json: plugin.errors, status: :unprocessable_entity
    end
  end

  def update
    begin @plugin.update! plugin_params
      head :no_content
    rescue
      render json: @plugin.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @plugin.destroy
    head :no_content
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_plugin
    @plugin = Plugin.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plugin_params
    params.require(:plugin).permit(:url)
  end
end
