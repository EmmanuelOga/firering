=begin
<room>
  <id type="integer">1</id>
  <name>North May St.</name>
  <topic>37signals HQ</topic>
  <membership-limit type="integer">60</membership-limit>
  <full type="boolean">false</full>
  <open-to-guests type="boolean">true</open-to-guests>
  <active-token-value>#{ 4c8fb -- requires open-to-guests is true}</active-token-value>
  <updated-at type="datetime">2009-11-17T19:41:38Z</updated-at>
  <created-at type="datetime">2009-11-17T19:41:38Z</created-at>
  <users type="array">
    ...
  </users>
</room>
=end

module Firering
  class Room < Firering::Data
    key :id, :name, :topic, :membership_limit, :full, :open_to_guests, :active_token_value, :updated_at, :created_at, :users

    def users
      @users ||= super.map { |u| Firering::User.new(u, false) }
    end
  end
end
