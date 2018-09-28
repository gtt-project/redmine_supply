module RedmineSupply
  class Action
    def self.call(*_)
      new(*_).call
    end
  end
end


