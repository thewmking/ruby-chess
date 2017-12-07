module Chess
  class Piece
    attr_accessor :color, :symbol, :position
    def initialize(color, position=nil)
      @color = color
      @position = position
    end

    def name
      self.class.name.to_s.downcase.gsub('chess::', '')
    end

    def dest_path(origin, dest)
      nil
    end
  end
end
