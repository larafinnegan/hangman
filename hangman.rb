require 'yaml'

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
    until word.length.between?(6, 13) && word == word.downcase
      word = lines[rand(lines.length)]
    end
    @board = Board.new(word.chars.to_a)
    @guesses = 12
    @letters = []
  end

  def menu
    puts "Would you like to start a new game or load a saved game?"
    puts "Presss 0 to start a new game, or enter the number of one of the following saved games:"
    Dir.exists?("saved_games") ? (puts Dir["saved_games/*"]) : (puts "No saved games!  Please press 0.")
    choice = gets.chomp
    count = Dir[File.join("saved_games", '**', '*')].count { |file| File.file?(file) }
    until ("0"..count.to_s).include?(choice)
      puts "Invalid input.  Please enter 0 for a new game, or the game number of a saved game:"
      choice = gets.chomp
    end
    if ("1"..count.to_s).include?(choice)
      File.open("saved_games/game_#{choice}.yaml") {|yf| YAML::load(yf) }
    end
  end

  def load_file
    File.open("saved_games/game_3.yaml") {|yf| YAML::load(yf) }
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

  def save_game
    Dir.mkdir("saved_games") unless Dir.exists? ("saved_games")
    count = Dir[File.join("saved_games", '**', '*')].count { |file| File.file?(file) }
    File.open("saved_games/game_#{count + 1}.yaml", "w") do |out|
      YAML.dump(self, out)
    end
  end

  def play
    puts "Welcome to Hangman!\n\n"
    menu if Dir.exists?("saved_games")
    board.display
    until @guesses == 0 || board.win?
      puts "\n\nYou have #{guesses} guesses remaining.\n\n"
      puts "You have already guessed the following letters: #{@letters.join(", ")}\n\n"
      check_guess
      board.display
      save_game
    end
    board.win? ? (puts "\n\nCongrats, you win!") : (puts "\n\nBetter luck next time!")
  end
end

game = Game.new
game.load_file