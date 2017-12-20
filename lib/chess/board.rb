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
      puts ""
      puts "BLACK"
      puts "  a b c d e f g h"
      i = 8
      grid.each do |row|
        puts "#{i.to_s} #{row.map { |cell| cell.value.nil? ? "_" : cell.value.symbol }.join(" ")} #{i.to_s}"
        i -= 1
      end
      puts "  a b c d e f g h"
      puts "WHITE"
    end

    def init_pieces
      # black pieces
      set_cell(0, 0, Rook.new("black", [0,0], "a8"))
      set_cell(1, 0, Knight.new("black", [1,0], "b8"))
      set_cell(2, 0, Bishop.new("black", [2,0], "c8"))
      set_cell(3, 0, Queen.new("black", [3,0], "d8"))
      set_cell(4, 0, King.new("black", [4,0], "e8"))
      set_cell(5, 0, Bishop.new("black", [5,0], "f8"))
      set_cell(6, 0, Knight.new("black", [6,0], "g8"))
      set_cell(7, 0, Rook.new("black", [7,0], "h8"))
      set_cell(0, 1, Pawn.new("black", [0,1], "a7"))
      set_cell(1, 1, Pawn.new("black", [1,1], "b7"))
      set_cell(2, 1, Pawn.new("black", [2,1], "c7"))
      set_cell(3, 1, Pawn.new("black", [3,1], "d7"))
      set_cell(4, 1, Pawn.new("black", [4,1], "e7"))
      set_cell(5, 1, Pawn.new("black", [5,1], "f7"))
      set_cell(6, 1, Pawn.new("black", [6,1], "g7"))
      set_cell(7, 1, Pawn.new("black", [7,1], "h7"))

      # white pieces
      set_cell(0, 7, Rook.new("white", [0,7], "a1"))
      set_cell(1, 7, Knight.new("white", [1,7], "b1"))
      set_cell(2, 7, Bishop.new("white", [2,7], "c1"))
      set_cell(3, 7, Queen.new("white", [3,7], "d1"))
      set_cell(4, 7, King.new("white", [4,7], "e1"))
      set_cell(5, 7, Bishop.new("white", [5,7], "f1"))
      set_cell(6, 7, Knight.new("white", [6,7], "g1"))
      set_cell(7, 7, Rook.new("white", [7,7], "h1"))
      set_cell(0, 6, Pawn.new("white", [0,6], "a2"))
      set_cell(1, 6, Pawn.new("white", [1,6], "b2"))
      set_cell(2, 6, Pawn.new("white", [2,6], "c2"))
      set_cell(3, 6, Pawn.new("white", [3,6], "d2"))
      set_cell(4, 6, Pawn.new("white", [4,6], "e2"))
      set_cell(5, 6, Pawn.new("white", [5,6], "f2"))
      set_cell(6, 6, Pawn.new("white", [6,6], "g2"))
      set_cell(7, 6, Pawn.new("white", [7,6], "h2"))
    end

    private

    def default_grid
      Array.new(8) { Array.new(8) {Cell.new}}
    end
  end
end
