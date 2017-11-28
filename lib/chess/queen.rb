module Chess
  class Queen < Piece
    def initialize(color, position=nil)
      super(color)
      @position = position
      if @color == "black"
        @symbol = "\u265B"
      else
        @symbol = "\u2655"
      end
    end
  end
end
