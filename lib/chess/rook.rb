module Chess
  class Rook < Piece
    def initialize(color, position, id)
      @color = color
      @position = position
      @id = id
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

    def dest_path(origin, dest)
      o_col, o_row, d_col, d_row = origin[0], origin[1], dest[0], dest[1]
      x, y = d_col - o_col, d_row - o_row
      cells = []

      if x != 0
        i = x.abs/x
        (x.abs - 1).times do
          cells << [o_col + i, o_row] if (0..7).include?(o_col + i)
          i += 1 if x > 0
          i -= 1 if x < 0
        end
      end

      if y != 0
        j = y.abs/y
        (y.abs - 1).times do
          cells << [o_col, o_row + j] if (0..7).include?(o_row + j)
          j += 1 if y > 0
          j -= 1 if y < 0
        end
      end
      cells
    end
  end
end
