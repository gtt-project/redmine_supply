module RedmineSupply
  class Action
    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    end
  end
end


