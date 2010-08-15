module Firering
  class Data
    # Generates methods to access the data stored in the @data Hash
    def self.data_attributes(*keys)
      include Module.new {
        keys.each do |key|
          module_eval <<-CODE, __FILE__, __LINE__
            def #{key}
              @_attributes[#{key.to_sym.inspect}]
            end
          CODE
        end
      }
    end

    attr_accessor :connection

    # factory method to instantiate data classes
    def self.instantiate(conn, data, base_key= nil, &callback)
      instance = new
      instance.connection = conn
      instance.initialize_attributes(data, base_key)
      callback.call(instance) if callback
      instance
    end

    # data is a hash or a json encoded hash (String)
    # base_key if present is the main data key on the hash.
    def initialize_attributes(data, base_key = nil)
      @_attributes = data.is_a?(Hash) ? data : Yajl::Parser.parse(data, :symbolize_keys => true)
      @_attributes = @_attributes[base_key] if base_key

      @_attributes.each do |key, val|
        @_attributes[key] = Date.parse(val) rescue val if key.to_s =~ /(_at|_on)$/
      end
    end

    def inspect
      "<#{self.class.name} #{@_attributes.inspect}>"
    end
  end
end
