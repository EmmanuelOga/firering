=begin
<message>
  <id type="integer">1</id>
  <room-id type="integer">1</room-id>
  <user-id type="integer">2</user-id>
  <body>Hello Room</body>
  <created-at type="datetime">2009-11-22T23:46:58Z</created-at>
  <type>#{TextMessage || PasteMessage || SoundMessage || AdvertisementMessage ||
          AllowGuestsMessage || DisallowGuestsMessage || IdleMessage || KickMessage ||
          LeaveMessage || SystemMessage || TimestampMessage || TopicChangeMessage ||
          UnidleMessage || UnlockMessage || UploadMessage}</type>
</message>
=end

module Firering
  class Message < Firering::Data
    key :id, :room_id, :user_id, :body, :created_at, :type

    MESSAGE_TYPES = %w[
      TextMessage PasteMessage SoundMessage AdvertisementMessage
      AllowGuestsMessage DisallowGuestsMessage IdleMessage KickMessage
      LeaveMessage SystemMessage TimestampMessage TopicChangeMessage
      UnidleMessage UnlockMessage UploadMessage
    ]

    # txs activesupport
    underscore = proc do |word|
      word.to_s.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
    end

    MESSAGE_TYPES.each do |message_type|
      current_type = (message_type =~ /(.+)Message/) && $1
      define_method("#{underscore[current_type]}?") do
        type == message_type
      end
    end

    def to_s
      "#{body} (#{user_id}, #{created_at})"
    end

  end
end
