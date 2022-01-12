class Game
  def initialize
    words = File.readlines("5desk.txt", chomp: true)
    randomize(words)
    @guesses = []
    @incorrect_guesses = []
    @incorrect_remaining = 6
    intro
  end

  def randomize(words)
    @word = []
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
      break if game_won?
      break if game_over?
      break if save? && save_game
    end
  end

  def intro
    puts "Let's play Hangman! Enter 1 to start a new game or 2 to load a saved game."
    puts "Enter 'save' at any point to save the game."
    #game_mode = gets.chomp
    game_mode = "1"
    new_game if game_mode == "1"
    load_game if game_mode == "2"
  end

  def load_game
    # puts list of saved games
    # puts "Enter the name of the saved game you wish to play:"
    # 
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
    guess_again?
  end
  
  def guess_again?
    if @guesses.include?(@guess) || @incorrect_guesses.include?(@guess)
      puts "\nYou've already guessed that letter! Try again."
      solicit_guess
    end
  end

  def check_answer
    if @guess.length == 1
      if @word.include?(@guess)
        @guesses << @guess
        add_letter
      else
        incorrect_guess
      end
    else
      @incorrect_remaining -= 1 if !correct_answer
    end
  end

  def display_letters
    puts "\n#{@dashes.join}" unless correct_answer
  end

  def add_letter
    @word.split("").each_with_index do |val, idx|
      @dashes[idx] = "#{@guess} "  if @guess == val
    end
  end

  def incorrect_guess
    @incorrect_guesses << @guess
    @incorrect_remaining -= 1
  end

  def save?
    @guess == "save"
  end

  def game_won?
    if correct_answer
      puts "\nYou win!\nThe word was: #{@word}"
      return true
    end
  end

  def correct_answer
    @guess == @word || @dashes.join.gsub(/\s+/, "") == @word
  end

  def game_over?
    if @incorrect_remaining == 0
      display_incorrect
      puts "\nGame over.\nThe word was: #{@word}"
      return true
    end
  end

  def save_game
    puts "Enter a name to save your game file as:"
    fname = gets.chomp
    fname = File.open("#{fname}.rb", "w")
    fname.puts Game
    fname.close
    puts "Game saved."
    return true
  end
end

Game.new