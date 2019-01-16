class Board
  attr_reader :squares

  @@alpha = %w(a b c d e f g h)

  def initialize
    @squares = {}
    8.times do |x|
      8.times do |y|
        coordinate = [x,y]
        @squares[coordinate] = nil
      end
    end
  end

  def convert(algebraic)
    if algebraic.is_a?(String) &&
       algebraic.length == 2 &&
       @@alpha.include?(algebraic.chars[0]) &&
       (1..8).to_a.include?(algebraic.chars[1].to_i)
      x = @@alpha.index(algebraic.chars[0])
      y = algebraic.chars[1].to_i - 1
      [x, y]
    else
      false
    end
  end

  def add_piece(piece, coordinate)
    if @squares[coordinate]
      false
    else
      @squares[coordinate] = piece
      true
    end
  end

  def remove_piece(coordinate)
    if @squares[coordinate]
      @squares[coordinate] = nil
      true
    else
      false
    end
  end

  def clearpath(origin, color, steps, *directions)
    clears = []
    enemies = []
    x, y = origin
    directions.each do |direction|
      direction_x, direction_y = direction
      steps.times do |i|
        delta_x, delta_y = direction_x * ( i + 1 ), direction_y * ( i + 1 )
        target = [x + delta_x, x + delta_y]
        break unless @squares.keys.include?(target)
        if square_color = @squares[target]
          enemies << target if color != square_color
          break
        else
          clears << target
        end
      end
    end
    [clears, enemies]
  end

end

class Piece
  attr_reader :moves, :takes, :color

  def initialize(color)
    @color = color
    @moves = []
    @takes = []
  end

  def pathfinding(current, board)
    @moves = []
    @takes = []
    @@directions.each do |direction|
      moves, takes = board.clearpath(current, @color, @@move_limit, direction)
      @moves += moves if moves
      @takes += takes if takes
    end
  end

end

class Rook < Piece
  @@directions = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
  @@move_limit = 7
end

class Bishop < Piece
  @@directions = [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
  @@move_limit = 7
end

class Queen < Piece
  @@directions = [ [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1] ]
  @@move_limit = 7
end

class King < Piece
  @@directions = [ [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1] ]
  @@move_limit = 1
end