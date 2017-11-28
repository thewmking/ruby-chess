module Chess
  class Bishop < Piece
    def initialize(color, position=nil)
      super(color)
      @position = position
      if @color == "black"
        @symbol = "\u265D"
      else
        @symbol = "\u2657"
      end
    end
  end
end
