class Game
  def initialize
    dictionary = File.open("5desk.txt", "r")
    words = File.readlines("5desk.txt", chomp: true)
    @word = []
    randomize(words)
    @guesses = []
    @incorrect_guesses = []
    @incorrect_remaining = 6
    intro
  end

  def randomize(words)
    until !@word.empty?
      @word = words.sample.downcase.gsub(/\W+/, '')
      randomize(words) if (@word.length < 5 || @word.length > 12)
    end
  end

  def new_game
    p @word
    draw_dashes
    loop do
      incorrect_remaining
      display_incorrect
      solicit_guess
      check_answer
      display_letters
      if game_won?
        puts "\nYou win!\nThe word was: #{@word}"
        break
      end
      if game_over?
        display_incorrect
        puts "\nGame over.\nThe word was: #{@word}"
        break
      end
    end
  end

  def intro
    puts "Let's play Hangman! Enter 1 to start a new game or 2 to load a saved game."
    puts "Enter 'save' at any point to save the game."
    game_mode = gets.chomp
    new_game if game_mode == "1"
  end

  def draw_dashes
    @dashes = []
    @word.length.times do
      @dashes << "_ "
    end
    puts @dashes.join
  end

  def incorrect_remaining
    puts "\nIncorrect guesses left: #{@incorrect_remaining}"
  end

  def display_incorrect
    puts "Incorrect: #{@incorrect_guesses.join(" ")}" if !@incorrect_guesses.empty?
  end

  def solicit_guess
    puts "\nEnter your guess (a letter or the entire word):"
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

  def display_letters
    puts "\n#{@dashes.join}" unless game_won?
  end

  def add_letters
    @word.split("").each_with_index do |val, idx|
      @dashes[idx] = "#{@guess} "  if @guess == val
    end
  end

  def incorrect_guess
    @incorrect_guesses << @guess
    @incorrect_remaining -= 1
  end

  def game_won?
    @guess == @word || @dashes.join.gsub(/\s+/, "") == @word
  end

  def game_over?
    @incorrect_remaining == 0
  end
end

game = Game.new