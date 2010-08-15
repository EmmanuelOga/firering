class Firering::Upload < Firering::Data

  data_attributes :id, :name, :room_id, :user_id, :byte_size, :content_type,
    :full_url, :created_at

end
