# frozen_string_literal: true
require 'devise/jwt'

Devise.setup do |config|
  # Mailer configuration
  config.mailer_sender = 'please-change-me@example.com'

  # Use ActiveRecord ORM
  require 'devise/orm/active_record'

  # JWT Setup — just secret and expiration time here
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.secret_key_base
    jwt.expiration_time = 1.day.to_i

    # These dispatch/revocation hooks won't be used since we're handling cookies manually
    jwt.dispatch_requests = []
    jwt.revocation_requests = []
  end

  # Auth configuration
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # We're using JWT manually → don't store sessions
  config.skip_session_storage = [:http_auth, :params_auth, :token_auth]

  # Password config
  config.stretches = Rails.env.test? ? 1 : 12
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Reset password config
  config.reset_password_within = 6.hours

  # Confirmable (optional)
  config.reconfirmable = true

  # Rememberable
  config.expire_all_remember_me_on_sign_out = true

  # Sign out via DELETE method
  config.sign_out_via = :delete

  # Disable navigational formats to prevent HTML redirects
  config.navigational_formats = []

  # Set default error and redirect status for API-only
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
