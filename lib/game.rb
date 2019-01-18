require './lib/board.rb'
require './lib/piece.rb'

class Game
  attr_reader :player1, :player2, :board

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    setup_board
    @specials = {}
  end

  def setup_board
    @board = Board.new
    [Rook.new('white'), Knight.new('white'), Bishop.new('white'), Queen.new('white'), King.new('white'), Bishop.new('white'), Knight.new('white'), Rook.new('white')].each_with_index do |piece, i|
      @board.add_piece(piece, [i, 0])
    end
    [Rook.new('black'), Knight.new('black'), Bishop.new('black'), Queen.new('black'), King.new('black'), Bishop.new('black'), Knight.new('black'), Rook.new('black')].each_with_index do |piece, i|
      @board.add_piece(piece, [i, 7])
    end
    8.times do |i|
      @board.add_piece(Pawn.new('white'), [i, 1])
      @board.add_piece(Pawn.new('black'), [i, 6])
    end
  end

  def select(target)
    piece = @board.squares[target]
    special = @specials[target]
    return {piece: piece, special: special} if piece
    false
  end

  def find_moves
    @board.squares.each do |coordinate, piece|
      piece.pathfinding(coordinate, @board) if piece
    end
  end

  def move(origin, target)
    piece = @board.squares[origin]
    @board.squares[target] = piece
    @board.squares[origin] = nil
    @specials = {}
    if piece.first_move
      piece.first_move = false
      if piece.class == Pawn && (target[1] - origin[1]).abs == 2
        en_passant?(target, piece.color)
      end
    end
    find_moves
  end

  def en_passant?(passant, color)
    x, y = passant
    move = (color == 'white')? [x, y - 1] : [x, y + 1]
    [ [(x - 1), y], [(x + 1), y] ].each do |target|
      if piece = @board.squares[target]
        if piece.class == Pawn && piece.color != color
          @specials[target] = { move: move, take: passant }
        end
      end
    end
  end

  def en_passant(origin, move, take)
    move(origin, move)
    @board.remove_piece(take)
  end

  def castling?
    kings = @board.squares.select { |square, piece| piece.class == King }
    kings.each do |king_square, king|
      if king.first_move
        rooks = @board.squares.select { |square, piece| piece.class == Rook && piece.color == king.color }
        rooks.each do |rook_square, rook|
          x, y = rook_square
          rook_move = (x == 0)? [3, y] : [5, y]
          if rook.first_move && rook.moves.include?(rook_move)
            king_x = (x == 0 )? 2 : 6
            @specials[king_square] = { move: [king_x, y], rook: rook_square, rook_move: rook_move }
          end
        end
      end
    end
  end

  def castling(king, king_move, rook, rook_move)
    move(king, king_move)
    move(rook, rook_move)
  end

  def load_board(pieces)
    @board.squares.each_key { |key| @board.remove_piece(key) }
    pieces.each do |piece|
      @board.squares[piece[:square]] = piece[:piece]
    end
  end

end