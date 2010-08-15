class Firering::Message < Firering::Data

  data_attributes :id, :room_id, :user_id, :body, :created_at, :type

  MESSAGE_TYPES = %w[
    TextMessage PasteMessage SoundMessage AdvertisementMessage
    AllowGuestsMessage DisallowGuestsMessage IdleMessage KickMessage
    LeaveMessage SystemMessage TimestampMessage TopicChangeMessage
    UnidleMessage UnlockMessage UploadMessage
  ]

  # txs activesupport
  underscore = proc do |word|
    w = word.to_s.gsub(/::/, '/')
    w = w.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    w = w.gsub(/([a-z\d])([A-Z])/,'\1_\2')
    w.tr("-", "_").downcase
  end

  MESSAGE_TYPES.each do |message_type|
    current_type = (message_type =~ /(.+)Message/) && $1
    define_method("#{underscore[current_type]}?") do
      type == message_type
    end
  end

  def from_user?
    !user_id.nil? && (!user_id.instance_of?(String) || user_id !~ /^\s*$/)
  end

  # Highlights a message / Removes a message highlight.
  def star(id, yes_or_no = true, &callback)
    connection.star_message(id, yes_or_no, &callback)
  end

  def room(&callback)
    connection.room(room_id, &callback)
  end

  def user(&callback)
    connection.user(user_id, &callback) if from_user?
  end

end
