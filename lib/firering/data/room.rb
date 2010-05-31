module Firering
  class Room < Firering::Data
    key :id, :name, :topic, :membership_limit, :full, :open_to_guests, :active_token_value, :updated_at, :created_at, :users, :locked

    alias_method :locked?, :locked
    alias_method :full?, :full
    alias_method :open_to_guests?, :open_to_guests

    def users
      @users ||= (super || []).map { |u| Firering::User.new(u, false) }
    end
  end
end
