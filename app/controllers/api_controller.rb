class ApiController < ApplicationController

  def common_ancestor
    a = params[:a].to_i
    b = params[:b].to_i

    result = ancestor_service.common_ancestor(a, b)
    render json: result
  end

  def birds
    node_ids = params[:node_ids]

    result = ancestor_service.get_descendant_birds(node_ids)

    render json: result
  end

  private

  def ancestor_service
    @ancestor_service ||= AncestorService.new
  end
end
