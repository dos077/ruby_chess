class Board
  attr_accessor :squares, :specials

  @@alpha = %w(a b c d e f g h)

  def initialize
    @squares = {}
    8.times do |x|
      8.times do |y|
        coordinate = [x,y]
        @squares[coordinate] = nil
      end
    end
    @specials = {}
  end

  def self.convert(algebraic)
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

  def revert(coordinate)
    x, y = coordinate
    "#{@@alpha[x]}#{y+1}"
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

  def clearpath(origin, color, move_limit, direction)
    clears = []
    enemies = []
    x, y = origin
    direction_x, direction_y = direction
    1.upto(move_limit) do |i|
      delta_x, delta_y = direction_x * i, direction_y * i
      target = [x + delta_x, y + delta_y]
      break unless @squares.keys.include?(target)
      if square_color = @squares[target]
        enemies << target if color != square_color
        break
      else
        clears << target
      end
    end
    [clears, enemies]
  end

  def find_moves
    @squares.each do |coordinate, piece|
      piece.pathfinding(coordinate, self) if piece
    end
  end

end