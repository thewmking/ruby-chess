module Chess
  class Knight < Piece
    def initialize(color, position=nil)
      super(color)
      @position = position
      if @color == "black"
        @symbol = "\u265E"
      else
        @symbol = "\u2658"
      end
    end
  end
end
