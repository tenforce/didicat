class Api::FiltersController < ApplicationController
  include PluginByRequestSupportMixin

  def create
    render :json => { :filter_key => plugin.filter.make_filter_key( request_info ) }
  end

end
