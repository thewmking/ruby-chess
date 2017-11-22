module Chess
  class Piece
    attr_accessor :color, :symbol, :position
    def initialize(color, position=nil)
      @color = color
      @position = position
    end
  end
end
