module Chess
  class Cell
    attr_accessor :value
    def initialize(value=nil)
      @value = value
    end

    def piece_type
      !self.value.nil? ? self.value.class : nil
    end

  end
end
