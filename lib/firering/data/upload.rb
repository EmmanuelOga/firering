module Firering
  Upload = Struct.new(:connection, :id, :name, :room_id, :user_id, :byte_size, :content_type, :full_url, :created_at)

  class Upload
    extend Instantiator
  end
end
