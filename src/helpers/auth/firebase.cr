require "crest"
require "jwt"
require "json"
require "openssl"

module Helpers
  module Auth
    module Firebase
      class Token
        getter payload
        getter header

        def initialize(@payload : JSON::Any, @header : Hash(String, JSON::Any))
        end

        def self.decode(token)
          decoded = JWT.decode token, algorithm: JWT::Algorithm::None, verify: false
          new decoded.first, decoded.last
        end

        def self.decode_and_verify(token)
          settings = Amber.settings.secrets

          decoded = JWT.decode token, PublicKey.find_by_kid(decode(token).header["kid"].to_s).pem,
            algorithm: JWT::Algorithm::RS256,
            aud: settings["project_id"],
            iss: settings["token_issuer"]

          new decoded.first, decoded.last
        end
      end

      struct PublicKey
        getter kid : String? = nil
        getter pem : String
        getter x509_cert : String

        def initialize(@kid, x509_certificate : String)
          @pem = public_key_pem x509_certificate
          @x509_cert = x509_certificate
        end

        def self.find_by_kid(kid)
          new kid, JSON.parse(x509_certs)[kid].to_s
        end

        def self.x509_certs
          Redis::CacheStore.connect.fetch("firebase:x509_certs", expires_in: 1.hours) do
            Crest.get("https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com").body
          end
        end

        private def public_key_pem(certificate)
          OpenSSL::X509::Certificate.new(certificate).public_key.to_pem
        end
      end
    end
  end
end
