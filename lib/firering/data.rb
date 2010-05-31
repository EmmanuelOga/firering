module Firering
  class Data

    # generates methods to access the data stored in the @data Hash
    def self.key(*keys)
      methods = keys.map do |key|
        <<-CODE
          def #{key}
            @data[#{key.to_sym.inspect}]
          end
        CODE
      end

      include(Module.new do
        module_eval methods.join("\n"), __FILE__, __LINE__
      end)
    end

    # data is a hash or a json encoded hash (String)
    # base_key if present is the main data key on the hash.
    def initialize(data, base_key = nil)
      @data = data.is_a?(Hash) ? data : Yajl::Parser.parse(data, :symbolize_keys => true)
      @data = @data[base_key] if base_key

      @data.each do |key, val|
        @data[key] = Date.parse(val) rescue val if key.to_s =~ /(_at|_on)$/
      end
    end

    def inspect
      "<#{self.class.name} #{@data.inspect}>"
    end

  end
end
