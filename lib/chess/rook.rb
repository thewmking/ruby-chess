module Chess
  class Rook < Piece
    def initialize(color, position=nil)
      super(color)
      @position = position
      if @color == "black"
        @symbol = "\u265C"
      else
        @symbol = "\u2656"
      end
    end
  end
end
