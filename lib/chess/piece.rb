module Chess
  class Piece
    attr_accessor :color, :symbol, :position, :id
    def initialize(color, position, id)
      @color = color
      @position = position
      @id = id
    end

    def name
      self.class.name.to_s.downcase.gsub('chess::', '')
    end

    def dest_path(origin, dest)
      nil
    end
  end
end
