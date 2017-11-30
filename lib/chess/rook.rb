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

    def possible_moves
      col = @position[0]
      row = @position[1]

      moves = []

      i = 1
      until i == 8
        moves << [col - i, row] if (0..7).include?(col - i)
        moves << [col + i, row] if (0..7).include?(col + i)
        moves << [col, row - i] if (0..7).include?(row - i)
        moves << [col, row + i] if (0..7).include?(row + i)
        i += 1
      end
      moves
    end
  end
end
