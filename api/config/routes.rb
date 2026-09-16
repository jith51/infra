require 'sidekiq/web'
require 'sidekiq/cron/web'

# include UserSession
# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "dna_indicateurs" => "indicateurs#dna"
  mount Sidekiq::Web => '/sidekiq'

  # graphql
  post "/graphql", to: "graphql#execute"
  post "/auth", to: "graphql_auth#execute"
  
end
