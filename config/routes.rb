Rails.application.routes.draw do
  root to: 'application#root'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :commands, only: [:show]
    end
  end

  match '*path', to: 'api/api#routing_error', via: :all
end
