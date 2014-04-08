module Firering
  module Instantiator

    def instantiate(conn, data, base_key = nil, &callback)
      instance = new
      instance.connection = conn

      attributes = data.is_a?(Hash) ? data : Yajl::Parser.parse(data, :symbolize_keys => true)
      attributes = attributes[base_key] if base_key
      attributes ||= Hash.new

      attributes.each do |key, val|
        setter = "#{key}="
        value = ( key.to_s =~ /(_at|_on)$/ ) ? (Time.parse(val) rescue val) : val
        if instance.respond_to?(setter)
          instance.send(setter, value)
        else
          msg = "WARNING: Could not set attribute '#{key}' to value '#{value}' on #{self} object."
          msg << " It is likely the Campfire API has changed. Please report this! (https://github.com/EmmanuelOga/firering/issues)"
          instance.connection.logger.warn msg
        end
      end

      callback.call(instance) if callback
      instance
    end

  end
end
