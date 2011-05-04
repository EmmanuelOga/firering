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
          Kernel.warn "WARNING: Tried to set #{setter} #{value.inspect} on a #{instance.class} instance but it didn't respond"
        end
      end

      callback.call(instance) if callback
      instance
    end

  end
end
