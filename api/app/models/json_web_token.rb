require 'jwt'

class JsonWebToken
  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    Rails.logger.info "payload: " + payload.to_s
    payload.reverse_merge!(meta)
    Rails.logger.info "secret: " + Rails.application.secrets.secret_key_base.to_s
    Rails.logger.info "secret_key_base: " + ENV["SECRET_KEY_BASE"].to_s
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
      return false
    else
      return true
    end
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: 1.days.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client',
    }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end
end