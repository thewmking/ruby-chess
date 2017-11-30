module Chess
  class Game
    attr_reader :players, :board, :current_player, :other_player
    def initialize(players, board = Board.new)
      @players = players
      @board = board
      @current_player, @other_player = players
    end

    def switch_players
      @current_player, @other_player = @other_player, @current_player
    end

    def move_prompt
      "#{current_player.name}: \nEnter a pair of coordinates to select your piece and move it. \ne.g. d2 d4"
    end

    def get_move(move = gets.chomp.downcase)
      if move =~ /\A[abcdefgh]\d\s[abcdefgh]\d\z/
        move = move.split(' ')
      else
        puts "Please use valid coordinates. Like this: a3 b5"
        get_move(move = gets.chomp.downcase)
      end
    end

    def play
      puts "The game has begun!"
      while true
        board.formatted_grid
        move_flow
        if board.game_over
          puts game_over_message
          board.formatted_grid
          return
        else
          switch_players
        end
      end
    end

    def move_flow
      puts ""
      puts move_prompt
      move = get_move
      verify_move(move)

    end

    def game_over_message
      return "#{current_player.name} won!" if board.game_over == :winner
      return "The game ended in a tie" if board.game_over == :draw
    end

    def verify_move(move)
      origin = human_move_to_coordinate(move[0])
      dest = human_move_to_coordinate(move[1])
      piece = @board.get_cell(origin[0],origin[1]).value
      dest_value = @board.get_cell(dest[0],dest[1]).value
      # if dest is in piece.possible_moves, set_cell
      if (piece.color == @current_player.color) && (piece != nil) && (piece.possible_moves.include? dest) && ((dest_value == nil) || (dest_value.color != piece.color))
        message = "#{piece.color} #{piece.name} moved from #{move[0]} to #{move[1]}"
        if dest_value != nil
          message = message + " and captured #{dest_value.color} #{dest_value.name}"
        end
        @board.set_cell(dest[0], dest[1], piece.class.new(piece.color, [dest[0], dest[1]]))
        @board.set_cell(origin[0], origin[1], nil)
        puts ""
        puts "________________________"
        puts ""
        puts message
      else
        puts "Not a valid move. Please try again."
        move_flow
      end
    end

    def human_move_to_coordinate(human_move)
      letter_map = {
        "a" => 0,
        "b" => 1,
        "c" => 2,
        "d" => 3,
        "e" => 4,
        "f" => 5,
        "g" => 6,
        "h" => 7
      }

      number_map = {
        "8" => 0,
        "7" => 1,
        "6" => 2,
        "5" => 3,
        "4" => 4,
        "3" => 5,
        "2" => 6,
        "1" => 7
      }

      move = [letter_map[human_move[0]], number_map[human_move[1]]]
    end

  end
end
