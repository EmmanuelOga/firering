class Firering::User < Firering::Data

  data_attributes :id, :name, :email_address, :admin, :created_at, :type,
    :api_auth_token

  alias_method :token, :api_auth_token
  alias_method :admin?, :admin

  def member?
    type == "Member"
  end

  def gest?
    type == "Guest"
  end

end
