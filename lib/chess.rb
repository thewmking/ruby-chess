require 'yaml'

module Chess
  class Chess
    def self.load_game
      puts "enter the filename [no .yml or similar file type extensions]"
      load_name = gets.chomp.downcase.strip
      saved_game = YAML.load(File.open("./save/#{load_name}.yml", "r"))
      puts "Game loaded!"
      saved_game
    end
  end
end

lib_path = File.expand_path(File.dirname(__FILE__))
Dir[lib_path + "/chess/**/*.rb"].each { |file| require file }
