class Game
  def initialize
    dictionary = File.open("5desk.txt", "r")
    words = File.readlines("5desk.txt", chomp: true)
    randomize(words)
    @guesses = []
    @incorrect_guesses = []
    @incorrect_remaining = 6
  end

  def randomize(words)
    @word = []
  
    until !@word.empty?
      @word = words.sample.downcase.gsub(/\W+/, '')
      randomize(words) if (@word.length < 5 || @word.length > 12)
    end
  end

  def play
    intro_text
    draw_dashes
    loop do
      incorrect_info
      solicit_guess
      check_answer
      puts @dashes.join unless game_won?
      if game_won?
        puts "You win!"
        break
      end
      if game_over?
        puts "Game over. The word was: #{@word}."
        break
      end
    end
  end

  def intro_text
    puts "Let's play Hangman! Enter 1 to start a new game or 2 to load a saved game."
    puts "Enter 'save' at any point to save the game." 
  end

  def draw_dashes
    @dashes = []
    @word.length.times do
      @dashes << "_ "
    end
    puts @dashes.join
  end

  def incorrect_info
    puts ""
    puts "Incorrect guesses left: #{@incorrect_remaining}"
    puts "Incorrect: #{@incorrect_guesses.join(" ")}" if !@incorrect_guesses.empty?
  end

  def solicit_guess
    puts ""
    puts "Enter your guess (a letter or the entire word):"
    @guess = gets.chomp.downcase
    if @guesses.include?(@guess) || @incorrect_guesses.include?(@guess)
      puts "You've already guessed that letter! Try again."
      solicit_guess
    end
  end

  def check_answer
    if @guess.length == 1
      if @word.include?(@guess)
        @guesses << @guess
        add_letters
      else
        incorrect_guess
      end
    else
      @incorrect_remaining -= 1 if !game_won?
    end
  end

  def add_letters
    @word.split("").each_with_index do |val, idx|
      @dashes[idx] = @guess if @guess == val
    end
  end

  def incorrect_guess
    @incorrect_guesses << @guess
    @incorrect_remaining -= 1
  end

  def game_won?
    @guess == @word || @dashes.join == @word
  end

  def game_over?
    @incorrect_remaining == 0
  end
end

game = Game.new
game.play


