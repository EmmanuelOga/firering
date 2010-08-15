module Firering
  module Requests

    # Calls /users/me route on campfire to get the authenticated user information, including token
    def authenticate(&callback)
      user("me") do |user|
        self.token = user.token
        callback.call(user)
      end
    end

    def user(id, &callback)
      http(:get, "/users/#{id}.json") do |http|
        Firering::User.instantiate(self, http.response, :user, &callback)
      end
    end

    def room(id, &callback)
      http(:get, "/room/#{id}.json") do |http|
        Firering::Room.instantiate(self, http.response, :room, &callback)
      end
    end

    # returns all rooms. For getting the users, each specific room must be queries with Firering.room
    # multi: if true, gets all the users from each room as Firering::User objects
    def rooms(&callback)
      http(:get, "/rooms.json") do |http|
        rooms = Yajl::Parser.parse(http.response, :symbolize_keys => true)[:rooms]
        rooms.map! { |room| Firering::Room.instantiate(self, room) }
        callback.call(rooms)
      end
    end

    # Returns all the messages containing the supplied term.
    def search_messages(query, &callback)
      http(:get, "/search/#{query}.json") do |http|
        messages = Yajl::Parser.parse(http.response, :symbolize_keys => true)[:messages]
        messages.map! { |msg| Firering::Message.instantiate(self, msg) }
        callback.call(messages)
      end
    end

    def star_message(id, yes_or_no = true, &callback)
      http(yes_or_no ? :post : :delete, "/messages/#{id}/star.json", &callback)
    end

  end
end
