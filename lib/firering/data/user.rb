module Firering
  User = Struct.new(:connection, :id, :name, :email_address, :admin, :created_at, :type, :api_auth_token)

  class User
    extend Instantiator

    alias_method :token, :api_auth_token
    alias_method :admin?, :admin

    def member?
      type == "Member"
    end

    def gest?
      type == "Guest"
    end

    alias_method :to_s, :name
  end
end
