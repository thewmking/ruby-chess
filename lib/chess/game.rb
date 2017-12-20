module Chess
  class Game
    attr_reader :players, :board, :current_player, :other_player, :move_list, :move
    def initialize(players, board = Board.new)
      @players = players
      @board = board
      @current_player, @other_player = players
      @move_list = []
      @move = nil
      puts "The game has begun!"
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
      elsif move == "board"
        board.formatted_grid
        move_prompt
        get_move(move = gets.chomp.downcase)
      elsif move == "castle"
        puts "Castle kingside or queenside?"
        side = gets.chomp.downcase.strip
        if side =~ /\A(queenside)|(kingside)\z/
          move = "#{move} #{side}"
        else
          puts "Please use valid input"
          get_move(move = gets.chomp.downcase)
        end
      elsif move == "save"
        save
      else
        puts "Please use valid coordinates. Like this: a3 b5"
        get_move(move = gets.chomp.downcase)
      end
    end

    def play
      while true
        board.formatted_grid
        move_flow
        switch_players
      end
    end

    def move_flow
      puts ""
      puts move_prompt
      if king_check > 0
        if check_checkmate == true
          puts "Checkmate. Game over."
          exit
        else
          puts "#{current_player.name}: \nYour king is in check. You must get your king out of check with your next move."
        end
      end
      @move = get_move
      if @move.include? "castle"
        if king_check > 0
          puts "You may not castle while your king is in check"
          not_valid
        else
          verify_castle(@move)
        end
      else
        verify_move(@move)
      end
    end

    def save
      Dir.mkdir('save') unless Dir.exists?('save')
      puts "Enter a name for your save file"
      save_name = gets.chomp.downcase.strip
      File.open("./save/#{save_name}.yml", 'w') do |file|
        file.write(YAML::dump(self))
      end
      puts "Game saved"
      exit
    end

    def game_over_message
      return "#{current_player.name} won!" if board.game_over == :winner
      return "The game ended in a tie" if board.game_over == :draw
    end

    def check_checkmate
      moves = get_all_moves(@current_player)
      move_count = moves.count
      moves.each do |move|
        move_count -= 1 if check_check(move[:piece], move[:piece].position, move[:dest]) > 0
        puts "available move: #{move}" if check_check(move[:piece], move[:piece].position, move[:dest]) == 0
      end
      puts move_count
      return true if move_count <= 0
    end

    def verify_castle(move)
      color = @current_player.color
      side = move.split(" ").last
      if color == "black"
        king = @board.get_cell(4,0).value
        if side == "queenside"
          rook = @board.get_cell(0,0).value
          king_dest, king_path = [2,0], [[3,0], [2,0]]
          rook_dest, rook_path = [3,0], [[1,0], [2,0], [3,0]]
        elsif side == "kingside"
          rook = @board.get_cell(7,0).value
          king_dest, king_path = [6,0], [[5,0], [6,0]]
          rook_dest, rook_path = [5,0], [[6,0], [5,0]]
        end
      else # color = white
        king = @board.get_cell(4,7).value
        if side == "queenside"
          rook = @board.get_cell(0,7).value
          king_dest, king_path = [2,7], [[3,7], [2,7]]
          rook_dest, rook_path = [3,7], [[1,7], [2,7]]
        elsif side == "kingside"
          rook = @board.get_cell(7,6).value
          king_dest, king_path = [6,7], [[5,7], [6,7]]
          rook_dest, rook_path = [5,7], [6,7]
        end
      end
      # if king & rook are present, accurate pieces, and have not moved
      if (king != nil) && (king.name == "king") && (king.color == color) &&
        (rook != nil) && (rook.name == "rook") && (rook.color == color) &&
        (check_move_list(king) == false) && (check_move_list(rook) == false)
        all_good = true

        #check if king & rook paths are empty
        path_values = king_path + rook_path
        path_values.each do |cell|
          all_good = false if @board.get_cell(cell[0], cell[1]).value != nil
        end
        #check king and path for check
        king_path.each do |cell|
          all_good = false if check_check(king, king.position, cell) > 0
        end
      end
      if all_good == true
        #set king and rook to new cells
        set_cells(king, king.position, king_dest)
        set_cells(rook, rook.position, rook_dest)
        puts "#{current_player.name} castled #{side}"
      else
        not_valid
      end
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
         ((dest_value == nil) || (dest_value.color != piece.color))
         all_good = true
        if piece.name == "pawn"
          puts "checking pawn moves"
          if pawn_move_check(origin, dest, piece, dest_value, last_move) == false
            all_good = false
          end
        end
        if check_check(piece, origin, dest) > 0
          all_good = false
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

    def check_check(piece, origin, dest)
      threat_count = 0
      current_board = Marshal.load(Marshal.dump(@board))
      set_cells(piece, origin, dest, current_board)
      threat_count = king_check(current_board)
      puts "That move would put your king in check" if threat_count > 0
      threat_count
    end

    # returns threat_count > 0 if king is in check
    def king_check(current_board=nil)
      current_board ||= @board
      threat_count = 0
      opponent_moves = get_all_moves(@other_player, current_board)
      opponent_moves.each do |move|
        threatened_cell = current_board.get_cell(move[:dest][0],move[:dest][1]).value
        if (threatened_cell != nil) && (threatened_cell.name == "king") && (threatened_cell.color == @current_player.color)
          threat_count +=1
          # diagnostics
          puts move
          puts "#{threatened_cell.color} king is threatened by #{move[:piece].color} #{move[:piece].name}"
        end
      end
      threat_count
    end

    def get_all_moves(player, current_board=nil)
      current_board ||= @board
      # get all possible moves from given player's pieces
      moves = []
      current_board.grid.each do |row|
        row.each do |cell|
          if (cell.value != nil) && (cell.value.color == player.color)
            cell.value.possible_moves.each do |move|
              piece = cell.value
              dest_value = current_board.get_cell(move[0],move[1]).value
              path_values = get_path_values(piece, piece.position, move, current_board)
              if piece.name == "pawn"
                if pawn_move_check(piece.position, move, piece, dest_value, @move_list.last) != false
                  moves << {dest: move, piece: piece}
                end
              elsif ["queen", "rook", "bishop"].include? piece.name
                if dest_value.nil?
                  moves << {dest: move, piece: piece} if (path_values.nil? || path_values.none?)
                else
                  moves << {dest: move, piece: piece} if dest_value.color != player.color && (path_values.nil? || path_values.none?)
                end
              else
                if dest_value.nil?
                  moves << {dest: move, piece: piece}
                else
                  moves << {dest: move, piece: piece} if dest_value.color != player.color
                end
              end
            end
          end
        end
      end
      moves
    end

    def check_move_list(piece)
      response = false
      @move_list.each do |move|
        response = true if move[:id] == piece.id
      end
      response
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

    def set_cells(piece, origin, dest, current_board=nil)
      current_board ||= @board
      if current_board == @board
        puts "moving #{piece.color} #{piece.name} from #{origin} to #{dest} in official board"
      else
        puts "moving #{piece.color} #{piece.name} from #{origin} to #{dest} in clone board"
      end
      current_board.set_cell(dest[0], dest[1], piece.class.new(piece.color, [dest[0], dest[1]], piece.id))
      current_board.set_cell(origin[0], origin[1], nil)
    end

    def set_move_list(piece, origin, dest)
      puts "adding move to move list"
      @move_list << {name: piece.name, color: piece.color, origin: origin, dest: dest, id: piece.id}
    end

    def check_promotion(piece, dest)
      if (piece.color == "white" && dest[1] == 0) || (piece.color == "black" && dest[1] == 7)
        message = "PROMOTION TIME!\nYour pawn made it to its eighth rank!\nChoose queen, bishop, knight, or rook."
        puts message
        input = gets.chomp.strip.downcase.capitalize
        if ["Queen", "Bishop", "Knight", "Rook"].include? input
          klass = Object.const_get('Chess::' + input)
          @board.set_cell(dest[0], dest[1], klass.new(piece.color, [dest[0], dest[1]], piece.id))
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
        end
      elsif ((dest[0] == origin[0]) && dest_value != nil) || ((dest[0] != origin[0]) && dest_value.nil?)
        return false
      end
    end

    def get_path_values(piece,origin,dest,current_board=nil)
      current_board ||= @board
      if (piece != nil)
        dest_path = piece.dest_path(origin, dest)
        path_values = []
        dest_path&.each do |cell|
          path_values << current_board.get_cell(cell[0],cell[1]).value
        end
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
