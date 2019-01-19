class Piece
  attr_reader :moves, :takes, :color
  attr_accessor :first_move

  def initialize(color)
    @color = color
    @moves = []
    @takes = []
    @first_move = true
  end

  def pathfinding(current, board)
    @moves = []
    @takes = []
    @directions.each do |direction|
      moves, takes = board.clearpath(current, @color, @move_limit, direction)
      @moves += moves if moves
      @takes += takes if takes
    end
  end

end

class Rook < Piece
  def pathfinding(current, board)
    @move_limit = 7
    @directions = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
    super
  end
  
  def display
    (@color=='black')? '♖' : '♜'
  end

end

class Bishop < Piece
  def pathfinding(current, board)
    @directions = [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
    @move_limit = 7
    super
  end

  def display
    (@color=='black')? '♗' : '♝'
  end

end

class Queen < Piece
  def pathfinding(current, board)
    @directions = [ [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1] ]
    @move_limit = 7
    super
  end

  def display
    (@color=='black')? '♕' : '♛'
  end

end

class King < Piece
  def pathfinding(current, board)
    @directions = [ [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1] ]
    @move_limit = 1
    super
  end

  def display
    (@color=='black')? '♔' : '♚'
  end

end

class Knight < Piece
  def pathfinding(current, board)
    @directions = [ [1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1] ]
    @move_limit = 1
    super
  end

  def display
    (@color=='black')? '♘' : '♞'
  end

end

class Pawn < Piece
  def pathfinding(current, board)
    @directions = (@color=='white')? [ [0, 1] ] : [ [0, -1] ]
    @move_limit = (first_move)? 2 : 1
    super
    @takes = []
    directions = (@color == 'white')? [ [-1, 1], [1, 1] ] : [ [-1, -1], [1, -1] ]
    directions.each do |direction|
        @takes += board.clearpath(current, @color, @move_limit, direction)[1]
    end
  end

  def display
    (@color=='black')? '♙' : '♟'
  end

end