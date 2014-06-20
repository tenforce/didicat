class Api::PluginsController < ApplicationController
  before_action :set_plugin, only: [:show, :edit, :update, :destroy]

  def index
    render json: Plugin.all, each_serializer: PluginSerializer
    # json: { plugins: Plugin.all.collect do |p| { url: p.url.to_s, id: p.url.to_s } end }
    #, each_serializer: PluginSerializer
  end

  def show
    render json: Plugin
  end

  def create
    begin
      Plugin.add_remote_plugin params[:plugin][:url]
      head :no_content, status: 200
    rescue
      render json: { error: "Could not fetch plugin" }, status: :unprocessable_entity
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
