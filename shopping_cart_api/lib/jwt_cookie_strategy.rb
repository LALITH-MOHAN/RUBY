module JWTCookieStrategy
    def self.call(request)
      request.cookie_jar.signed[:jwt]
    end
  end