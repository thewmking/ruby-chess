module Chess
  class King < Piece
    def initialize(color, position=nil)
      super(color)
      @position = position
      if @color == "black"
        @symbol = "\u265A"
      else
        @symbol = "\u2654"
      end
    end
  end
end
