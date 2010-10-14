module Firering
  module Instantiator

    def instantiate(conn, data, base_key = nil, &callback)
      instance = new
      instance.connection = conn

      attributes = data.is_a?(Hash) ? data : Yajl::Parser.parse(data, :symbolize_keys => true)
      attributes = attributes[base_key] if base_key
      attributes ||= Hash.new

      attributes.each do |key, val|
        value = ( key.to_s =~ /(_at|_on)$/ ) ? (Date.parse(val) rescue val) : val
        instance.send("#{key}=", value)
      end

      callback.call(instance) if callback
      instance
    end

  end
end
