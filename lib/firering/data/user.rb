=begin
<user>
  <id type="integer">1</id>
  <name>Jason Fried</name>
  <email-address>jason@37signals.com</email-address>
  <admin type="boolean">#{true || false}</admin>
  <created-at type="datetime">2009-11-20T16:41:39Z</created-at>
  <type>#{Member || Guest}</type>
  <api-auth-token>90454e67ebe1e202034a49266cc0abf0de7e538e</api-auth-token>
</user>
=end

module Firering
  class User  < Firering::Data
    key :id, :name, :email_address, :admin, :created_at, :type, :api_auth_token

    alias_method :token, :api_auth_token

    def admin?
      admin
    end

    def member?
      type == "Member"
    end

    def gest?
      type == "Guest"
    end
  end
end
