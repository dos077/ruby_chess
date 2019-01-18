require './lib/game.rb'

RSpec.describe Game do
  describe '#setup_board' do
    game = Game.new('p1', 'p2')
    it { expect(game.select([0, 0])[:piece].class).to eql(Rook) }
    it { expect(game.select([1, 0])[:piece].class).to eql(Knight) }
    it { expect(game.select([2, 0])[:piece].class).to eql(Bishop) }
    it { expect(game.select([4, 0])[:piece].class).to eql(King) }
    it { expect(game.select([0, 1])[:piece].class).to eql(Pawn) }
    it { expect(game.select([3, 7])[:piece].class).to eql(Queen) }
    it { expect(game.select([7, 6])[:piece].class).to eql(Pawn) }
    it { expect(game.select([0, 6])[:piece].color).to eql('black') }
    it { expect(game.select([5, 1])[:piece].color).to eql('white') }
    it { expect(game.select([0, 2])).to be false }
  end

  describe '@board#find_moves' do
    game = Game.new('p1', 'p2')
    it { expect(game.select([0, 0])[:piece].moves.count).to eql(0) }
    it { expect(game.select([0, 1])[:piece].moves.count).to eql(2) }
    it { expect(game.select([6, 7])[:piece].moves.count).to eql(2) }
  end

  describe '#move' do
    game = Game.new('p1', 'p2')
    game.move([0, 1], [0, 3])
    it { expect(game.select([0, 3])[:piece].class).to eql(Pawn) }
    it { expect(game.select([0, 1])).to be false }
  end

  describe '#en_passant?' do
    game = Game.new('p1', 'p2')
    game.load_board( [ {square: [0, 1], piece: Pawn.new('white')}, {square: [1, 3], piece: Pawn.new('black')} ] )
    game.move([0, 1], [0, 3])
    special = game.select([1, 3])[:special]
    it { expect(special[:take]).to eql([0, 3]) }
    game.en_passant([1, 3], special[:move], special[:take])
    it { expect(game.select([0, 3])).to be false }
    it { expect(game.select([0, 2])[:piece].color).to eql('black') }
  end

  describe '#castling?' do
    game = Game.new('p1', 'p2')
    white_king = {square: Board.convert('e1'), piece: King.new('white')}
    white_rook= {square: Board.convert('h1'), piece: Rook.new('white')}
    black_king = {square: Board.convert('e8'), piece: King.new('black')}
    black_rook = {square: Board.convert('a8'), piece: Rook.new('black')}
    game.load_board([white_king, white_rook, black_king, black_rook])
    game.castling?
    white_castling = game.select([4, 0])[:special]
    black_castling = game.select([4, 7])[:special]
    it { expect(white_castling[:rook]).to eql(white_rook[:square]) }
    it { expect(black_castling[:move]).to eql([2, 7]) }
    it { expect(black_castling[:rook_move]).to eql([3, 7]) }
    game.castling(white_king[:square], white_castling[:move], white_castling[:rook], white_castling[:rook_move])
    it { expect(game.select([6, 0])[:piece].class).to eql(King) }
    it { expect(game.select([5, 0])[:piece].class).to eql(Rook) }
  end

  describe '#check and #checkmate' do
    game = Game.new('p1', 'p2')
    white_king = {square: Board.convert('h1'), piece: King.new('white')}
    black_bishop1 = {square: Board.convert('e3'), piece: Bishop.new('black')}
    black_bishop2 = {square: Board.convert('f3'), piece: Bishop.new('black')}
    black_king = {square: Board.convert('h3'), piece: King.new('black')}
    game.load_board([white_king, black_bishop1, black_bishop2, black_king])
    it { expect(game.check('white')).to be true }
    it { expect(game.check('black')).to be false }
    it { expect(game.checkmate('white')).to be true }
    it { expect(game.checkmate('black')).to be false }
  end

  describe '#pawn_promote' do
    game = Game.new('p1', 'p2')
    white_pawn = {square: [0, 0], piece: Pawn.new('white')}
    game.load_board([white_pawn])
    game.pawn_promote([0, 0], 'white', Queen)
    it { expect(game.select([0, 0])[:piece].class).to eql(Queen) }
  end

end