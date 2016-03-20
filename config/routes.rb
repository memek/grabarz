Rails.application.routes.draw do
  root to: 'application#root'
  match '*path', to: 'api/api#routing_error', via: :all
end
