module RedmineSupply
  class Unit
    def self.all
      @units
    end
    def self.load(file)
      @units = Hash[
        YAML.load(IO.read file)["units"].each_with_index.map do |unit, idx|
          [unit.to_sym, idx + 1]
        end
      ]
    end
  end
end
