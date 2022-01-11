class Game
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
    draw_dashes
    6.times do
      solicit_guess
      letter_guess
      if game_won?
        puts "You win!"
        break
      end
    end
  end

  def draw_dashes
    dashes = ""
    @word.length.times do
      dashes += "_ "
    end
    puts dashes
  end

  def solicit_guess
    puts ""
    puts "Enter your guess (a letter or the entire word):"
    @guess = gets.chomp.downcase
  end

  def letter_guess
    if @guess.length == 1
      
    end
  end

  def game_won?
    @guess == @word
  end
end

game = Game.new
game.play


