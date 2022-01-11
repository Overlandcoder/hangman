class Game
  def initialize
    dictionary = File.open("5desk.txt", "r")
    words = File.readlines("5desk.txt", chomp: true)
    randomize(words)
    @guesses = []
    @wrong_guesses = []
    @turns_remaining = 6
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
    loop do
      puts "Incorrect guesses left: #{@turns_remaining}"
      solicit_guess
      letter_guess
      puts @dashes.join unless game_won?
      if game_won?
        puts "You win!"
        break
      end
      if game_over?
        puts "Game over."
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
    if @guesses.include?(@guess) || @wrong_guesses.include?(@guess)
      puts "You've already guessed that letter! Try again."
      solicit_guess
    end
  end

  def letter_guess
    if @guess.length == 1
      if @word.include?(@guess)
        @guesses << @guess
        give_feedback
      else
        wrong_guess
      end
    end
  end

  def give_feedback
    @word.split("").each_with_index do |val, idx|
      @dashes[idx] = @guess if @guess == val
    end
  end

  def wrong_guess
    @wrong_guesses << @guess
    puts "Incorrect: #{@wrong_guesses.join(" ")}"
    @turns_remaining -= 1
  end

  def game_won?
    @guess == @word
  end

  def game_over?
    @turns_remaining == 0
  end
end

game = Game.new
game.play


