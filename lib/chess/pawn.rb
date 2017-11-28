module Chess
  class Pawn < Piece
    def initialize(color, position=nil)
      super(color)
      @position = position
      if @color == "black"
        @symbol = "\u265F"
      else
        @symbol = "\u2659"
      end
    end
  end
end
