module Chess
  class Queen < Piece
    def initialize(color, position=nil)
      super(color)
      @position = position
      if @color == "black"
        @symbol = "\u265B"
      else
        @symbol = "\u2655"
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
        moves << [col - i, row - i] if (0..7).include?(col - i) && (0..7).include?(row - i)
        moves << [col - i, row + i] if (0..7).include?(col - i) && (0..7).include?(row + i)
        moves << [col + i, row + i] if (0..7).include?(col + i) && (0..7).include?(row + i)
        moves << [col + i, row - i] if (0..7).include?(col + i) && (0..7).include?(row - i)
        i += 1
      end
      moves
    end

    def dest_path(origin, dest)
      o_col, o_row, d_col, d_row = origin[0], origin[1], dest[0], dest[1]
      x,y = d_col - o_col, d_row - o_row
      cells = []

      if (x != 0 && y != 0) && (x.abs == y.abs)
        i = x.abs/x
        j = y.abs/y
        (x.abs - 1).times do
          cells << [o_col + i, o_row + j] if (0..7).include?(o_col + i) && (0..7).include?(o_row + j)
          i += 1 if x > 0
          i -= 1 if x < 0
        end
      elsif x != 0 && y == 0
        i = x.abs/x
        (x.abs - 1).times do
          cells << [o_col + i, o_row] if (0..7).include?(o_col + i)
          i += 1 if x > 0
          i -= 1 if x < 0
        end
      elsif y != 0 && x == 0
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
