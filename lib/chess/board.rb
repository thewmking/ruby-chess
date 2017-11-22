module Chess
  class Board
    attr_reader :grid
    def initialize(input = {})
      @grid = input.fetch(:grid, default_grid)
    end

    def get_cell(x,y)
      grid[y][x]
    end

    def set_cell(x, y, value)
      get_cell(x, y).value = value
    end

    def formatted_grid
      puts "a b c d e f g h"
      i = 8
      grid.each do |row|
        puts i + row.map { |cell| cell.value.empty? ? "_" : cell.value }.join(" ") + i
        i -= 1
      end
      puts "a b c d e f g h"
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
