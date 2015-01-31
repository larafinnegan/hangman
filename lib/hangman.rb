require 'yaml'
require_relative 'board.rb'

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
    puts "Welcome to Hangman!\n\n"
    menu
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
    choice == "0" ? play : load_file(choice) 
  end

  def load_file(choice)
    saved_game = YAML::load(File.read("saved_games/game_#{choice}.yaml"))
    saved_game.play
  end

  def guess
    puts "Please guess a letter or press 1 to save and exit the game:\n\n"
    guess = gets.chomp.downcase
    if guess == "1"
      save_game
      exit
    end
    until ("a".."z").to_a.include?(guess) && !letters.include?(guess) 
      puts "That's not a letter, please try again." unless ("a".."z").to_a.include?(guess)
      puts "You already tried that letter, guess again!" if letters.include?(guess) 
      guess = gets.chomp.downcase
    end
    letters << guess
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
    board.display
    until guesses == 0 || board.win?
      puts "\n\nYou have #{guesses} incorrect guesses remaining.\n\n"
      puts "You have already guessed the following letters: #{@letters.join(", ")}\n\n"
      check_guess
      board.display
    end
    board.win? ? (puts "\n\nCongrats, you win!") : (puts "\n\nThe word is '#{board.word[0..-2].join}'","Better luck next time!")
  end
end

game = Game.new