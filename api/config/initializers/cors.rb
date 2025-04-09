# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins "http://localhost:3000"
    # origins "http://10.80.122.133:4000"
    origins '*'

    resource "*",
      # headers: :any,
      # methods: [:get, :post, :put, :patch, :delete, :options, :head]
      headers: %w(Authorization token Expires RefreshToken),
      methods: :any,
      expose: %w(Authorization token Expires RefreshToken),
      max_age: 600
  end
end
# # Rails.
# application.config.middleware.insert_before 0, Rack::Cors do
# #   allow do
# #     origins 'http://example.com:80'
# #     resource '*', headers: :any, methods: [:get, :post]
# #   end
# end