root = File.expand_path("../", File.dirname(__FILE__))
require_relative "#{root}/lib/chess.rb"

puts "Welcome to the game of CHESS"
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
