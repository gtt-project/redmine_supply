module RedmineSupply
  class Quantity
    attr_accessor :value

    def initialize(value)
      @value = value.to_f
    end

    def to_s
      sprintf "%.2f", value
    end
  end
end
