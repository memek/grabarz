module RenderErrors
  def render_404
    render json: {
      error: 'Not found'
    }, status: 404
  end

  def render_500
    render json: {
      error: 'Internal server error'
    }, status: 500
  end
end
