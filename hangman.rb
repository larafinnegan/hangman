class Board
  attr_accessor :board, :word

  def initialize(word, board=Array.new(word.length-1, "_"))
    @word = word
    @board = board
    puts word
  end

  def display
    print board.join(" ")
  end

  def win?
    board.none? {|x| x == "_"}
  end

  def update?(guess)
    word.each_with_index {|letter, index| board[index] = letter if letter == guess}
    word.include?(guess)
  end
end


class Game
  attr_accessor :board, :guesses, :letters

  def initialize
    lines = File.readlines("words.txt")
    word = ""
    while word.length < 6 || word.length > 13 || word == word.capitalize
      word = lines[rand(lines.length)]
    end
    @board = Board.new(word.chars.to_a)
    @guesses = 12
    @letters = []
  end

  def guess
    puts "Please guess a letter:\n\n"
    guess = gets.chomp.downcase
    until ("a".."z").to_a.include?(guess) && !letters.include?(guess) 
      puts "That's not a letter, please try again." unless ("a".."z").to_a.include?(guess)
      puts "You already tried that letter, guess again!" if letters.include?(guess) 
      guess = gets.chomp.downcase
    end
    @letters << guess
    guess
  end

  def check_guess
    if board.update?(guess)
      puts "Good guess!\n\n"
    else
      puts "Sorry, the word doesn't contain that letter.\n\n"
      @guesses -= 1 
    end
  end

  def play
    puts "Welcome to Hangman!\n\n"
    board.display
    until @guesses == 0 || board.win?
      puts "\n\nYou have #{guesses} guesses remaining.\n\n"
      puts "You have already guessed the following letters: #{@letters.join(", ")}\n\n"
      check_guess
      board.display
    end
    board.win? ? (puts "\n\nCongrats, you win!") : (puts "\n\nBetter luck next time!")
  end
end

game = Game.new
game.play

