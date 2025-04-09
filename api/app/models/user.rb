require "securerandom"
class User < ActiveRecord::Base
  # Include default devise modules.
  has_secure_password

end
