class Board
  attr_accessor :board, :word

  def initialize(word, board=Array.new(word.length-1, "_"))
    @word = word
    @board = board
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
