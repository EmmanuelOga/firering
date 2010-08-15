module Firering
  module Requests

    # Calls /users/me route on campfire to get the authenticated user information, including token
    def authenticate(&callback)
      user("me") do |user|
        self.token = user.token
        callback.call(user)
      end
    end

    # returns a user by id
    def user(id, &callback)
      http(:get, "/users/#{id}.json") do |data, http|
        Firering::User.instantiate(self, data, :user, &callback)
      end
    end

    # returns a room by id
    def room(id, &callback)
      http(:get, "/room/#{id}.json") do |data, http|
        Firering::Room.instantiate(self, data, :room, &callback)
      end
    end

    # Returns all rooms. For getting the users, each specific room must be queries with Firering.room
    # multi: if true, gets all the users from each room as Firering::User objects
    def rooms(&callback)
      http(:get, "/rooms.json") do |data, http|
        callback.call(data[:rooms].map{|room| Firering::Room.instantiate(self, room)}) if callback
      end
    end

    # Returns all the messages containing the supplied term.
    def search_messages(query, &callback)
      http(:get, "/search/#{query}.json") do |data, http|
        callback.call(data[:messages].map { |msg| Firering::Message.instantiate(self, msg) }) if callback
      end
    end

    # Toggles the star next to a message
    def star_message(id, yes_or_no = true, &callback)
      http(yes_or_no ? :post : :delete, "/messages/#{id}/star.json") do |data, http|
        callback.call(data) if callback
      end
    end

  end
end
