# frozen_string_literal: true

Devise.setup do |config|
  # Mailer Configuration
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Load and configure the ORM
  require 'devise/orm/active_record'

  # Case-insensitive and whitespace-stripped keys
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # Skip session storage for http auth
  config.skip_session_storage = [:http_auth]

  # Password configuration
  config.stretches = Rails.env.test? ? 1 : 12
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours

  # Clean CSRF tokens after auth
  config.clean_up_csrf_token_on_authentication = true

  # Rememberable
  config.expire_all_remember_me_on_sign_out = true

  # Reconfirmable
  config.reconfirmable = true

  # Sign out via DELETE request
  config.sign_out_via = :delete

  # Hotwire/Turbo error/redirect codes
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ===> JWT Configuration
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise_jwt_secret_key || 'your_jwt_secret_key'
    
    # Match these to your login/logout endpoints
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]

    jwt.expiration_time = 1.day.to_i

    # Request format for token extraction
    jwt.request_formats = {
      user: [:json]
    }
  end
end
