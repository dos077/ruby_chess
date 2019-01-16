require './lib/board.rb'
require './lib/piece.rb'

RSpec.shared_examples 'piece examples' do |piece, move_count, moves, takes|
  board = Board.new
  d2 = board.convert('d2'); e2 = board.convert('e2'); f3 = board.convert('f3')
  e3 = board.convert('e3')
  board.add_piece(piece, d2)
  board.add_piece(Pawn.new('white'), e2)
  board.add_piece(Pawn.new('white'), f3)
  board.add_piece(Pawn.new('white'), e3)
  piece.pathfinding(d2, board)
  
  it { expect(piece.moves.length).to eql(move_count) }
  moves.each do |move|
    it { expect(piece.moves.include?(board.convert(move))).to be true }
  end
  takes.each do |take|
    it { expect(piece.takes.include?(board.convert(take))).to be true }
  end
end

RSpec.describe Rook do
  include_examples 'piece examples', Rook.new('black'), 10, ['a2', 'd1', 'd8'], ['e2']
end

RSpec.describe Bishop do
  include_examples 'piece examples', Bishop.new('black'), 5, ['e1', 'a5', 'c1'], ['e3']
end

RSpec.describe Queen do
  include_examples 'piece examples', Queen.new('black'), 15, ['a2', 'd1', 'd8', 'e1', 'a5', 'c1'], ['e3', 'e2']
end

RSpec.describe King do
  include_examples 'piece examples', King.new('black'), 6, ['c3', 'd1'], ['e2']
end

RSpec.describe Pawn do
  include_examples 'piece examples', Pawn.new('black'), 2, ['d3'], ['e3']
end

RSpec.describe Knight do
  include_examples 'piece examples', Knight.new('black'), 5, ['f1', 'c4'], ['f3']
end