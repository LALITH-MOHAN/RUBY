# frozen_string_literal: true
require 'devise/jwt'

Devise.setup do |config|
  # ==> JWT configuration
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.secret_key_base

    # Only dispatch JWT on login, NOT on registration
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}]
    ]

    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]

    jwt.expiration_time = 1.day.to_i
  end

  # ==> Mailer Configuration
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  # config.mailer = 'Devise::Mailer'
  # config.parent_mailer = 'ActionMailer::Base'

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # ==> Authentication config
  # config.authentication_keys = [:email]
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  # config.params_authenticatable = true
  # config.http_authenticatable = false
  # config.http_authenticatable_on_xhr = true
  # config.http_authentication_realm = 'Application'
  # config.paranoid = true

  config.skip_session_storage = [:http_auth, :params_auth, :token_auth]
  # config.clean_up_csrf_token_on_authentication = true
  # config.reload_routes = true

  # ==> :database_authenticatable config
  config.stretches = Rails.env.test? ? 1 : 12
  # config.pepper = '...'

  # config.send_email_changed_notification = false
  # config.send_password_change_notification = false

  # ==> :confirmable
  # config.allow_unconfirmed_access_for = 2.days
  # config.confirm_within = 3.days
  config.reconfirmable = true
  # config.confirmation_keys = [:email]

  # ==> :rememberable
  # config.remember_for = 2.weeks
  config.expire_all_remember_me_on_sign_out = true
  # config.extend_remember_period = false
  # config.rememberable_options = {}

  # ==> :validatable
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> :timeoutable
  # config.timeout_in = 30.minutes

  # ==> :lockable
  # config.lock_strategy = :failed_attempts
  # config.unlock_keys = [:email]
  # config.unlock_strategy = :both
  # config.maximum_attempts = 20
  # config.unlock_in = 1.hour
  # config.last_attempt_warning = true

  # ==> :recoverable
  # config.reset_password_keys = [:email]
  config.reset_password_within = 6.hours
  # config.sign_in_after_reset_password = true

  # ==> :encryptable
  # config.encryptor = :sha512

  # ==> Scopes configuration
  # config.scoped_views = false
  # config.default_scope = :user
  # config.sign_out_all_scopes = true

  # ==> Navigation configuration
  # config.navigational_formats = ['*/*', :html, :turbo_stream]

  config.sign_out_via = :delete

  # ==> OmniAuth
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'

  # ==> Warden
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end

  # ==> Hotwire/Turbo
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ==> :registerable
  # config.sign_in_after_change_password = true
end
