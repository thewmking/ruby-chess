module Chess
  class Game
    attr_reader :players, :board, :current_player, :other_player, :move_list, :move
    def initialize(players, board = Board.new)
      @players = players
      @board = board
      @current_player, @other_player = players
      @move_list = []
      @move = nil
    end

    def switch_players
      @current_player, @other_player = @other_player, @current_player
    end

    def move_prompt
      "#{current_player.name}: \nEnter a pair of coordinates to select your piece and move it. \ne.g. d2 d4"
    end

    def get_move(move = gets.chomp.downcase)
      if move =~ /\A[abcdefgh]\d\s[abcdefgh]\d\z/
        move = move.strip.split(' ')
      elsif ["quit", "exit"].include? move
        exit
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
      @move = get_move
      verify_move(@move)

    end

    def game_over_message
      return "#{current_player.name} won!" if board.game_over == :winner
      return "The game ended in a tie" if board.game_over == :draw
    end

    def verify_move(move)
      puts "setting origin"
      origin = human_move_to_coordinate(move[0])
      puts "setting destination"
      dest = human_move_to_coordinate(move[1])
      puts "setting piece"
      piece = @board.get_cell(origin[0],origin[1]).value
      puts "setting dest_value"
      dest_value = @board.get_cell(dest[0],dest[1]).value
      puts "getting path values"
      path_values = get_path_values(piece,origin,dest)
      puts "getting last move"
      last_move = @move_list.last

      if (piece != nil) && (piece.color == @current_player.color) &&
         (piece.possible_moves.include? dest) && ((path_values.nil? || path_values.none?)) &&
         ((dest_value == nil) || (dest_value.color != piece.color)) #&& (last_move[:color] != piece.color unless last_move.nil?)
         all_good = true
        if piece.name == "pawn"
          puts "checking pawn moves"
          if pawn_move_check(origin, dest, piece, dest_value, last_move) == false
            all_good = false
          end
        end
        if all_good == true
          set_message(piece, move, dest_value)
          set_cells(piece, origin, dest)
          set_move_list(piece, origin, dest)
          if piece.name == "pawn"
            check_promotion(piece, dest)
          end
        else
          not_valid
        end
      else
        not_valid
      end
    end

    def set_message(piece, move, dest_value)
      puts "setting message"
      message = "#{piece.color} #{piece.name} moved from #{move[0]} to #{move[1]}"
      if dest_value != nil
        message = message + " and captured #{dest_value.color} #{dest_value.name}"
      end
      puts " \n________________________\n "
      puts message
    end

    def set_cells(piece, origin, dest)
      @board.set_cell(dest[0], dest[1], piece.class.new(piece.color, [dest[0], dest[1]]))
      @board.set_cell(origin[0], origin[1], nil)
    end

    def set_move_list(piece, origin, dest)
      puts "adding move to move list"
      @move_list << {name: piece.name, color: piece.color, origin: origin, dest: dest}
    end

    def check_promotion(piece, dest)
      if (piece.color == "white" && dest[1] == 0) || (piece.color == "black" && dest[1] == 7)
        message = "PROMOTION TIME!\nYour pawn made it to its eighth rank!\nChoose queen, bishop, knight, or rook."
        puts message
        input = gets.chomp.strip.downcase.capitalize
        if ["Queen", "Bishop", "Knight", "Rook"].include? input
          klass = Object.const_get('Chess::' + input)
          @board.set_cell(dest[0], dest[1], klass.new(piece.color, [dest[0], dest[1]]))
          puts "Promoted #{piece.color} #{piece.name} to #{input.capitalize}"
        else
          check_promotion(piece, dest)
        end
      end
    end

    def pawn_move_check(origin, dest, piece, dest_value, last_move)
      if (last_move != nil && last_move[:name] == 'pawn') && (dest[0] != origin[0]) &&
        ((origin[0] == (last_move[:dest][0] + 1)) || (origin[0] == (last_move[:dest][0] - 1))) &&
        (last_move[:origin][0] == last_move[:dest][0]) && (last_move[:origin][1] == (1 || 6))
        if ((piece.color == 'white') && (origin[1] == 3) && (last_move[:origin][1] == 1) && (last_move[:dest][1] == (last_move[:origin][1] + 2))) ||
          ((piece.color == 'black') && (origin[1] == 4) && (last_move[:origin][1] == 6) && (last_move[:dest][1] == (last_move[:origin][1] - 2)))
          @board.set_cell(last_move[:dest][0], last_move[:dest][1], nil)
          puts "Captured en passant!"
        else
          puts "failed pawn check 1. starting over move flow"
        end
      elsif ((dest[0] == origin[0]) && dest_value != nil) || ((dest[0] != origin[0]) && dest_value.nil?)
        puts "failed pawn check 2. starting over move flow"
        return false
      else
        puts "continuing as normal"
      end
    end

    def get_path_values(piece,origin,dest)
      if (piece != nil)
        dest_path = piece.dest_path(origin, dest)
        path_values = []
        dest_path&.each do |cell|
          path_values << @board.get_cell(cell[0],cell[1]).value
        end
        puts "path values are #{path_values}"
        path_values
      end
    end

    def not_valid
      puts "Not a valid move. Please try again."
      puts "setting move to nil"
      @move = nil
      move_flow
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
