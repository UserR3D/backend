class User < ApplicationRecord
  has_secure_password

  def as_json(options={})
    super(options.merge({except: [:password_digest]}))
  end
end
