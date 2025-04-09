module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      Rails.logger.warn("this is the info I read from the cookie:")
    end
  end
end
