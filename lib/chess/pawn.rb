module Chess
  class Pawn < Piece

    def initialize(color, position, id)
      @color = color
      @position = position
      @id = id
      if @color == "black"
        @symbol = "\u265F"
      else
        @symbol = "\u2659"
      end
    end

    def possible_moves
      col = @position[0]
      row = @position[1]

      moves = []

      if @color == "black" # row + 1, col +- 1
        moves << [col, row + 2] if row == 1 # first move option for two spaces
        moves << [col, row + 1] if (0..7).include?(row + 1)
        moves << [col + 1, row + 1] if (0..7).include?(col + 1) && (0..7).include?(row + 1)
        moves << [col - 1, row + 1] if (0..7).include?(col - 1) && (0..7).include?(row + 1)
      else # row - 1, col +- 1
        moves << [col, row - 2] if row == 6 # first move option for two spaces
        moves << [col, row - 1] if (0..7).include?(row - 1)
        moves << [col + 1, row - 1] if (0..7).include?(col + 1) && (0..7).include?(row - 1)
        moves << [col - 1, row - 1] if (0..7).include?(col - 1) && (0..7).include?(row - 1)
      end
      moves
    end
  end
end
