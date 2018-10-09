module RedmineSupply
  class Quantity
    attr_reader :value

    def initialize(value, precision: 3)
      @value = value.to_f
      @precision = precision
    end

    # Quantity.(float_or_quantity) => always a quantity
    def self.call(value, *args)
      if self === value
        value
      else
        new value, *args
      end
    end

    def to_s
      sprintf "%.#{@precision}f", value
    end
  end
end
