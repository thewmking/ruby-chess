module Chess
  class King < Piece

    def initialize(color, position, id)
      @color = color
      @position = position
      @id = id
      if @color == "black"
        @symbol = "\u265A"
      else
        @symbol = "\u2654"
      end
    end

    def possible_moves
      col = @position[0]
      row = @position[1]

      moves = []

      moves << [col - 1, row] if (0..7).include?(col - 1)
      moves << [col + 1, row] if (0..7).include?(col + 1)
      moves << [col, row - 1] if (0..7).include?(row - 1)
      moves << [col, row + 1] if (0..7).include?(row + 1)
      moves << [col - 1, row - 1] if (0..7).include?(col - 1) && (0..7).include?(row - 1)
      moves << [col - 1, row + 1] if (0..7).include?(col - 1) && (0..7).include?(row + 1)
      moves << [col + 1, row + 1] if (0..7).include?(col + 1) && (0..7).include?(row + 1)
      moves << [col + 1, row - 1] if (0..7).include?(col + 1) && (0..7).include?(row - 1)

      moves
    end
  end
end
