module Chess
  class Board
    attr_reader :grid
    def initialize(input = {})
      @grid = input.fetch(:grid, default_grid)
      init_pieces
    end

    def get_cell(x,y)
      grid[y][x]
    end

    def set_cell(x, y, value)
      get_cell(x, y).value = value
    end

    def formatted_grid
      puts "  a b c d e f g h"
      i = 8
      grid.each do |row|
        puts "#{i.to_s} #{row.map { |cell| cell.value.nil? ? "_" : cell.value.symbol }.join(" ")} #{i.to_s}"
        i -= 1
      end
      puts "  a b c d e f g h"
    end

    def init_pieces
      # black pieces
      set_cell(0, 0, Rook.new("black", [0,0]))
      set_cell(1, 0, Knight.new("black", [1,0]))
      set_cell(2, 0, Bishop.new("black", [2,0]))
      set_cell(3, 0, Queen.new("black", [3,0]))
      set_cell(4, 0, King.new("black", [4,0]))
      set_cell(5, 0, Bishop.new("black", [5,0]))
      set_cell(6, 0, Knight.new("black", [6,0]))
      set_cell(7, 0, Rook.new("black", [7,0]))
      set_cell(0, 1, Pawn.new("black", [0,1]))
      set_cell(1, 1, Pawn.new("black", [1,1]))
      set_cell(2, 1, Pawn.new("black", [2,1]))
      set_cell(3, 1, Pawn.new("black", [3,1]))
      set_cell(4, 1, Pawn.new("black", [4,1]))
      set_cell(5, 1, Pawn.new("black", [5,1]))
      set_cell(6, 1, Pawn.new("black", [6,1]))
      set_cell(7, 1, Pawn.new("black", [7,1]))

      # white pieces
      set_cell(0, 7, Rook.new("white", [0,7]))
      set_cell(1, 7, Knight.new("white", [1,7]))
      set_cell(2, 7, Bishop.new("white", [2,7]))
      set_cell(3, 7, Queen.new("white", [3,7]))
      set_cell(4, 7, King.new("white", [4,7]))
      set_cell(5, 7, Bishop.new("white", [5,7]))
      set_cell(6, 7, Knight.new("white", [6,7]))
      set_cell(7, 7, Rook.new("white", [7,7]))
      set_cell(0, 6, Pawn.new("white", [0,6]))
      set_cell(1, 6, Pawn.new("white", [1,6]))
      set_cell(2, 6, Pawn.new("white", [2,6]))
      set_cell(3, 6, Pawn.new("white", [3,6]))
      set_cell(4, 6, Pawn.new("white", [4,6]))
      set_cell(5, 6, Pawn.new("white", [5,6]))
      set_cell(6, 6, Pawn.new("white", [6,6]))
      set_cell(7, 6, Pawn.new("white", [7,6]))
    end

    private

    def default_grid
      Array.new(8) { Array.new(8) {Cell.new}}
    end

    def draw?
    end

    def winner?
    end

  end
end
