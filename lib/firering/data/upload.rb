=begin
<upload>
  <id type="integer">1</id>
  <name>picture.jpg</name>
  <room-id type="integer">1</room-id>
  <user-id type="integer">1</user-id>
  <byte-size type="integer">10063</byte-size>
  <content-type>image/jpeg</content-type>
  <full-url>http://account.campfirenow.com/room/1/uploads/1/picture.jpg</full-url>
  <created-at type="datetime">2009-11-20T23:25:14Z</created-at>
</upload>
=end

module Firering
  class Upload < Firering::Data
    key :id, :name, :room_id, :user_id, :byte_size, :content_type, :full_url, :created_at
  end
end
