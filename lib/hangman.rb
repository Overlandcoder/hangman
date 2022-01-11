class Game
  def initialize
    dictionary = File.open("5desk.txt", "r")
    words = File.readlines("5desk.txt", chomp: true)
    randomize(words)
  end

  def randomize(words)
    @word = []
  
      until !@word.empty?
        if (words.sample.length >= 5 && words.sample.length <= 12)
          @word = words.sample.downcase.gsub(/\W+/, '')
        end
      end
  end

  def play
    p @word
    draw_dashes
    4.times do
      solicit_guess
      letter_guess
      update_dashes
      if game_won?
        puts "You win!"
        break
      end
    end
  end

  def draw_dashes
    @dashes = []
    @word.length.times do
      @dashes << "_ "
    end
    puts @dashes.join
  end

  def solicit_guess
    puts ""
    puts "Enter your guess (a letter or the entire word):"
    @guess = gets.chomp.downcase
  end

  def letter_guess
    if @guess.length == 1
      place_letter if @word.include?(@guess)
    end
  end

  def place_letter
    @word.split("").each_with_index do |val, idx|
      @dashes[idx] = @guess if @guess == val
    end
  end

  def update_dashes
    puts @dashes.join
  end

  def game_won?
    @guess == @word
  end
end

game = Game.new
game.play


