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

    def possible_moves
      col = @position[0]
      row = @position[1]

      moves = []

      moves << [col - 2, row - 1] if (0..7).include?(col - 2) && (0..7).include?(row - 1)
      moves << [col - 2, row + 1] if (0..7).include?(col - 2) && (0..7).include?(row + 1)
      moves << [col + 2, row - 1] if (0..7).include?(col + 2) && (0..7).include?(row - 1)
      moves << [col + 2, row + 1] if (0..7).include?(col + 2) && (0..7).include?(row + 1)
      moves << [col - 1, row - 2] if (0..7).include?(col - 1) && (0..7).include?(row - 2)
      moves << [col - 1, row + 2] if (0..7).include?(col - 1) && (0..7).include?(row + 2)
      moves << [col + 1, row - 2] if (0..7).include?(col + 1) && (0..7).include?(row - 2)
      moves << [col + 1, row + 2] if (0..7).include?(col + 1) && (0..7).include?(row + 2)

      moves
    end
  end
end
