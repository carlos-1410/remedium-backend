class ApplicationController < ActionController::API
  DEFAULT_PER_PAGE = 25

  def pagination_attributes(resources)
    meta = Common::PaginationAttributes.new(resources).call
    meta.merge(per_page: filterer_params[:per_page] || DEFAULT_PER_PAGE)
  end

  def render_exception(message, status: :unprocessable_entity, **other)
    render status: status, json: { error: message, **other }
  end
end
