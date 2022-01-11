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
    solicit_guess
    game_won?
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
    letter_guess if @guess.length == 1
    game_won? if @guess.length > 1
  end

  def letter_guess
    
  end

  def game_won?
    if @guess == @word
      puts "You win!"
    end
  end
end

game = Game.new
game.play


