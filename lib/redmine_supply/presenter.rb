module RedmineSupply
  class Presenter < Action

    private

    def h(s)
      ERB::Util.h s
    end
  end
end
