require './lib/game.rb'

class GameController

  def initialize
    puts "To start a new game of chest, please tell me your name."
    player1 = gets.chomp
    puts "#{player1} you are white."
    puts "Now who are you going up against?"
    player2 = gets.chomp
    puts "#{player2} you are black"
    @game = Game.new(player1, player2)
    play
  end

  def play
    loop do
      display
      player, color = (@game.turn.even?)? [@game.player2, 'black'] : [@game.player1, 'white']
      check = false
      if @game.check(color)
        if @game.checkmate(color)
          puts "checkmate!"
          break
        end
        puts "#{player} you are in check!"
        check = true
      end
      origin = nil
      piece = nil
      special = nil
      until origin
        origin, piece, special = get_selection(player, color) 
      end
      puts "Your #{piece.class} can"
      if piece.moves.any?
        move_list = ""
        piece.moves.each { |move| move_list += "#{@game.board.revert(move)}, " }
        puts "move to: #{move_list}"
      end
      if piece.takes.any?
        take_list = ""
        piece.takes.each { |take| take_list += "#{@game.board.revert(take)}, " }
        puts "take: #{take_list}"
      end
      if special
        puts "move to #{@game.board.revert(special[:move])} for its special move"
      end
      target = nil
      until target
        target = get_target
        if check && !@game.uncheck?(origin, target, color)
          puts "That's not a legal move when you are in check."
          target = nil
          next
        end
        if piece.moves.include?(target) || piece.takes.include?(target)
          @game.move(origin, target)
          @game.next_turn
        elsif special && special[:move] == target
          @game.en_passant(origin, special[:move], special[:take]) if piece.class == Pawn
          @game.castling(origin, special[:move], special[:rook], special[:rook_move]) if piece.class == King
          @game.next_turn
        elsif target != 'cancel'
          puts "That's not a legal move."
          target = nil
        end
      end
    end

  end

  def get_selection(player, color)
    origin = nil
    piece = nil
    special = nil
    puts "#{player} please tell me which piece you wish to move."
    origin = Board.convert(gets.chomp.downcase)
    if origin
      if @game.select(origin)
        piece = @game.select(origin)[:piece]
        special = @game.board.specials[origin]
      end
      if (!piece || piece.color != color)
        origin = nil
        puts "there isn't any of your pieces in that square" 
      elsif !( piece.moves.any? || piece.takes.any? || special )
        origin = nil
        puts "the piece cannot move."
      end
    else
      puts "that's not a square on the board."
    end
    [origin, piece, special]
  end

  def get_target
    target = nil
    puts "Now tell me which square you wish to move the piece, or cancel if you wish to move a different piece."
    response = gets.chomp.downcase
    if response == 'cancel'
      target = response
    else
      target = Board.convert(response)
    end
    target
  end

  def display
    system "clear"
    screen = "   | a | b | c | d | e | f | g | h |\n"
    8.times do |i|
      y = 7 - i
      screen += "---+---+---+---+---+---+---+---+---\n"
      screen += " #{y + 1} |"
      8.times do |x|
        cell = "   |"
        if square = @game.select([x, y])
          cell = " #{square[:piece].display} |"
        end
        screen += cell
      end
      screen += " #{y + 1}\n"
    end
    screen += "---+---+---+---+---+---+---+---+---\n"
    screen += "   | a | b | c | d | e | f | g | h |\n"
    puts screen
  end
  
end