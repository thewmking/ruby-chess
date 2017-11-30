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

    def possible_moves
      col = @position[0]
      row = @position[1]

      moves = []

      i = 1
      until i == 8
        moves << [col - i, row - i] if (0..7).include?(col - i) && (0..7).include?(row - i)
        moves << [col - i, row + i] if (0..7).include?(col - i) && (0..7).include?(row + i)
        moves << [col + i, row + i] if (0..7).include?(col + i) && (0..7).include?(row + i)
        moves << [col + i, row - i] if (0..7).include?(col + i) && (0..7).include?(row - i)
        i += 1
      end
      moves
    end
  end
end
