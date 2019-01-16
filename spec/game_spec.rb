require './lib/game.rb'

RSpec.describe Board do
  describe '#initialize' do
    board = Board.new
    it "creates a board with 64 spaces" do
      expect(board.squares.count).to eql(64)
    end
  end

  describe "#convert?" do
    board = Board.new
    it "check for legal algebraic notion" do
      expect(board.convert('h9')).to be false
    end
    it "return false for random phrase" do
      expect(board.convert('hello?')).to be false
    end
    it "returns the coordinate for the algebraic notion" do
      expect(board.convert('h8')).to eql([7, 7])
    end
  end

  describe '#add_piece' do
    board = Board.new
    a1 = board.convert('a1')
    it 'adds an object to the desinated square' do
      board.add_piece('rook', a1)
      expect(board.squares[a1]).to eql('rook')
    end
    it 'returns false if the space is already occupy' do
        expect(board.add_piece('knight', a1)).to be false
    end
  end

  describe '#clearpath' do
    board = Board.new
    black_rook = Rook.new('black')
    white_rook = Rook.new('white')
    a1 = board.convert('a1')
    a2 = board.convert('a2')
    board.add_piece(black_rook, a1)
    board.add_piece(white_rook, a2)
    moves, takes = board.clearpath(a1, black_rook.color, 8, [1, 0], [0, 1])
    it 'returns two lists, first clear spaces' do
      expect(moves.count).to eql(7)
    end
    it 'second enemies' do
      expect(takes.count).to eql(1)
    end
    it 'the clear list contains the [x, y] of the squares' do
      expect(moves.include?(board.convert('h1'))).to be true
    end
    it 'so does the enemies list' do
      expect(takes.include?(a2)).to be true
    end
    it 'returns no moves when the piece is surrounded' do
      board.add_piece(black_rook, board.convert('b1'))
      moves, takes = board.clearpath(a1, black_rook.color, 8, [1, 0], [0, 1])
      expect(moves.empty?).to be true
    end
  end

end
