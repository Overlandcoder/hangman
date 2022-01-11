class Game

  def initialize
    dictionary = File.open("5desk.txt", "r")
    words = File.readlines("5desk.txt", chomp: true)
    random_word(words)
  end


  def random_word(words)
  @word = ""

    until !@word.empty?
      if (words.sample.length >= 5 && words.sample.length <= 12)
        @word = words.sample
      end
    end
  end

  def play
    p @word
    draw_dashes
  end

  def draw_dashes
    dashes = ""
    puts @word.length
    @word.length.times do
      dashes += "_"
    end
    puts dashes
  end
end

class Board


end

game = Game.new
game.play


