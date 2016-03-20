module Api
  class ApiController < ActionController::Metal
    include RenderErrors
    include AbstractController::Helpers

    WITHOUT = [
      # AbstractController::Rendering,
      AbstractController::Translation,
      AbstractController::AssetPaths,
      ActionController::UrlFor,
      ActionController::Redirecting,
      # ActionController::Rendering,
      # ActionController::Renderers::All,
      # ActionView::Layouts,
      ActionController::ConditionalGet,
      ActionController::Caching,
      ActionController::MimeResponds,
      # ActionController::ImplicitRender,
      ActionController::Cookies,
      ActionController::Flash,
      ActionController::RequestForgeryProtection,
      ActionController::ForceSSL,
      ActionController::Streaming,
      ActionController::DataStreaming,
      ActionController::HttpAuthentication::Basic::ControllerMethods,
      ActionController::HttpAuthentication::Digest::ControllerMethods,
      ActionController::HttpAuthentication::Token::ControllerMethods,
      ActionController::Instrumentation,
      # ActionController::Rescue,
      ActionController::ParamsWrapper
    ]
    ActionController::Base.without_modules(*WITHOUT).each do |left|
      include left
    end

    self.view_paths << 'app/views/api'

    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, with: :render_500
      rescue_from ActionController::RoutingError, with: :render_404
      rescue_from ActionController::UnknownController, with: :render_404
    end

    def routing_error
      raise ActionController::RoutingError, params[:path]
    end
  end
end
