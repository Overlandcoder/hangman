class Game
  attr_reader :word

  def initialize
    dictionary = File.open("5desk.txt", "r")
    words = File.readlines("5desk.txt", chomp: true)
    randomize(words)
  end

  def randomize(words)
    @word = ""
  
      until !@word.empty?
        if (words.sample.length >= 5 && words.sample.length <= 12)
          @word = words.sample.downcase
        end
      end
  end

  def play
    p @word
    board = Board.new
    board.draw_dashes(@word)
  end
end

class Board

  def draw_dashes(word)
    dashes = ""
    puts word.length
    word.length.times do
      dashes += "_"
    end
    puts dashes
  end
end

game = Game.new
game.play


