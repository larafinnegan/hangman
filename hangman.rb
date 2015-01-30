class Player

end


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

def turn(guess)
word.each_with_index {|letter, index| board[index] = letter if letter == guess}
end


end

class Game
attr_accessor :board, :player, :guesses, :letters

def initialize
  lines = File.readlines("words.txt")
  word = ""
  while word.length < 5 || word.length > 12 || word == word.capitalize
  word = lines[rand(lines.length)]
  end
  @board = Board.new(word.chars.to_a)
  @guesses = 0
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
 guess
 end
 
 def play
 puts "Welcome to Hangman!"
 board.display
 board.turn(guess)
 board.display
 end
 
 
 end
 
 game = Game.new
 game.play

