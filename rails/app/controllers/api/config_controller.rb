class Api::ConfigController < ApplicationController

  def index
    render :json => {
      :peer_group => {
        :contact_point => Cfg.own_contact_point,
        :peer_cnntr => Cfg.peer_cnnctr_url,
        :peer_group => Cfg.peer_cnnctr_peer_group
      },
      :triple_store => {
        :sparql_endpoint => Cfg.endpoint,
        :graph => Cfg.active_sparql_graph
      }
    }.to_json
  end

end
