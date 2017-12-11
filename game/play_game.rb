root = File.expand_path("../", File.dirname(__FILE__))
require_relative "#{root}/lib/chess.rb"

puts "Welcome to the game of"
puts " .----------------.  .----------------.  .----------------.  .----------------.  .----------------.
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| |     ______   | || |  ____  ____  | || |  _________   | || |    _______   | || |    _______   | |
| |   .' ___  |  | || | |_   ||   _| | || | |_   ___  |  | || |   /  ___  |  | || |   /  ___  |  | |
| |  / .'   \\_|  | || |   | |__| |   | || |   | |_  \\_|  | || |  |  (__ \\_|  | || |  |  (__ \\_|  | |
| |  | |         | || |   |  __  |   | || |   |  _|  _   | || |   '.___`-.   | || |   '.___`-.   | |
| |  \\ `.___.'\\  | || |  _| |  | |_  | || |  _| |___/ |  | || |  |`\\____) |  | || |  |`\\____) |  | |
| |   `._____.'  | || | |____||____| | || | |_________|  | || |  |_______.'  | || |  |_______.'  | |
| |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------' "
puts "player 1 enter your name"
player_name_1 = gets.chomp
puts "hello #{player_name_1}! You will be playing as white."
puts "player 2 enter your name"
player_name_2 = gets.chomp
puts "hello #{player_name_2}! You will be playing as black"

player_1 = Chess::Player.new({color: "white", name: "#{player_name_1}"})
player_2 = Chess::Player.new({color: "black", name: "#{player_name_2}"})
players = [player_1, player_2]
Chess::Game.new(players).play
