require './lib/board.rb'

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

  describe '#remove_piece' do
    board = Board.new
    a1 = board.convert('a1')
    a2 = board.convert('a2')
    board.add_piece('rook', a1)
    it 'returns false if the space is not occupy' do
      expect(board.remove_piece(a2)).to be false
    end
    it 'removes an object at the desinated square' do
      board.remove_piece(a1)
      expect(board.squares[a1]).to eql(nil)
    end
  end

end