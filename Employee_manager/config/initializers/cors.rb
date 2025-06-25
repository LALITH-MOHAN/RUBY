Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'  # Replace '*' with your frontend URL in production
  
      resource '*',
        headers: :any,
        expose: ['Authorization'], # Expose JWT token
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end
  