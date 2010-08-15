module Helpers

  def conn
    @conn ||= Firering::Connection.new("http://localhost:#{$specs_port}", "http://localhost:#{$specs_port}") do |conn|
      conn.logger = $specs_logger
      conn.login = "user"
      conn.password = "password"
    end
  end

end
