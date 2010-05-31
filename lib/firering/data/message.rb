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

    def from_user?
      !user_id.nil? && (!user_id.instance_of?(String) || user_id !~ /~\s*$/)
    end

  end
end
