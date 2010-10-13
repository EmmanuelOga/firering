class Firering::Room < Firering::Data

  data_attributes :id, :name, :topic, :membership_limit, :full, :open_to_guests,
    :active_token_value, :updated_at, :created_at, :users, :locked

  alias_method :locked?, :locked
  alias_method :full?, :full
  alias_method :open_to_guests?, :open_to_guests

  def stream(&callback)
    join { |data, http| connection.stream(self, &callback) }
  end

  # we perform a request each time so
  # 1) we always are are up to date with the users currently on the room (even if some left)
  # 2) we make sure the users are here even if the room was instantiated from a
  # /rooms request
  def users(&callback)
    connection.http(:get, "/room/#{id}.json") do |data, http| # data can be blank on locked rooms
      callback.call(data ? data[:room][:users].map { |user| Firering::User.instantiate(self, user) } : Array.new) if callback
    end
  end

  # Updates an existing room. Only admins can rename a room, although any
  # user (except guests) may set the topic. Omitting either key results in
  # that attribute being ignored. To remove a room topic, simply provide an
  # empty topic key.
  #
  # update "name" => "Name", "topic" => "Topic"
  def update(data, &callback)
    connection.http(:put, "/room/#{id}.json", { :room => data }, &callback)
  end

  # Returns a collection of upto 100 recent messages in the room. Accepts an
  # additional optional parameter ‘limit’ to restrict the number of messages
  # returned.
  def recent_messages(limit = nil, &callback)
    connection.http(:get, "/room/#{id}/recent.json", (limit ? { :limit => limit } : nil)) do |data, http|
      callback.call(data[:messages].map { |msg| Firering::Message.instantiate(connection, msg) }) if callback
    end
  end

  # Returns all the messages sent today to a room.
  def today_transcript(&callback)
    connection.http(:get, "/room/#{id}/transcript.json") do |data, http|
      callback.call(data[:messages].map { |msg| Firering::Message.instantiate(connection, msg) }) if callback
    end
  end

  # Returns all the messages sent on a specific date to a room.
  def transcript(year, month, day, &callback)
    connection.http(:get, "/room/#{id}/transcript/#{year}/#{month}/#{day}.json") do |data, http|
      callback.call(data[:messages].map { |msg| Firering::Message.instantiate(connection, msg) }) if callback
    end
  end

  # Join a room.
  def join(&callback)
    connection.http(:post, "/room/#{id}/join.json", &callback)
  end

  # Leave a room.
  def leave(&callback)
    connection.http(:post, "/room/#{id}/leave.json", &callback)
  end

  # Locks a room.
  def lock(&callback)
    connection.http(:post, "/room/#{id}/lock.json", &callback)
  end

  # Unlocks a room.
  def unlock(&callback)
    connection.http(:post, "/room/#{id}/unlock.json", &callback)
  end

  # Sends a new message with the currently authenticated user as the sender.
  # The XML for the new message is returned on a successful request.
  #
  # The valid types are:
  #
  # * TextMessage  (regular chat message)
  # * PasteMessage (pre-formatted message, rendered in a fixed-width font)
  # * SoundMessage (plays a sound as determined by the message, which can be either “rimshot”, “crickets”, or “trombone”)
  # * TweetMessage (a Twitter status URL to be fetched and inserted into the chat)
  #
  # If an explicit type is omitted, it will be inferred from the content (e.g.,
  # if the message contains new line characters, it will be considered a paste).
  #
  # :type => "TextMessage",  :body => "Hello"
  def speak(data, &callback)
    connection.http(:post, "/room/#{id}/speak.json", "message" => data) do |data, http| # Response Status: 201 Created
      callback.call(Firering::Message.instantiate(connection, data))
    end
  end

  def text(text, &callback)
    speak({:type => "TextMessage", :body => text}, &callback)
  end

  def paste(paste, &callback)
    speak({:type => "PasteMessage", :body => paste}, &callback)
  end

  def rimshot(&callback)
    speak({:type => "SoundMessage", :body => "rimshot"}, &callback)
  end

  def crickets(&callback)
    speak({:type => "SoundMessage", :body => "crickets"}, &callback)
  end

  def trombone(&callback)
    speak({:type => "SoundMessage", :body => "trombone"}, &callback)
  end

  def tweet(tweet_url, &callback)
    speak({:type => "TweetMessage", :body => tweet_url}, &callback)
  end
end
