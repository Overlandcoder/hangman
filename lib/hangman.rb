require 'yaml'

class Game
  attr_reader :word, :guesses, :dashes, :incorrect_guesses, :incorrect_remaining

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

  def play_new_game
    p @word
    draw_dashes
    loop do
      display_incorrect_remaining
      display_incorrect_guesses
      solicit_guess
      break if save? && save_game
      check_answer
      display_letters
      break if game_won?
      break if game_over?
    end
  end

  def play_game
    p @word
    loop do
      display_incorrect_remaining
      display_letters
      display_incorrect_guesses
      solicit_guess
      break if save? && save_game
      check_answer
      break if game_won?
      break if game_over?
    end
  end

  def intro
    puts "Let's play Hangman! Enter 1 to start a new game or 2 to load a saved game."
    puts "Enter 'save' at any point to save the game."
    game_mode = gets.chomp
    play_new_game if game_mode == "1"
    play_saved_game if game_mode == "2"
  end

  def play_saved_game
    puts "\nSaved games:"
    puts Dir["saved/*"]
    puts "\nEnter the name of the saved game you wish to play:"
    game = gets.chomp
    load_game(game)
  end

  def load_game(game)
    saved_game = YAML.load(File.read("saved/#{game}"))
    @word = saved_game.word
    @guesses = saved_game.guesses
    @dashes = saved_game.dashes
    @incorrect_guesses = saved_game.incorrect_guesses
    @incorrect_remaining = saved_game.incorrect_remaining
    play_game
  end

  def saved_games
    Dir["saved/*.yaml"]
  end

  def draw_dashes
    @dashes = []
    @word.length.times do
      @dashes << "_ "
    end
    puts @dashes.join
  end

  def display_incorrect_remaining
    puts "\nIncorrect guesses left: #{@incorrect_remaining}"
  end

  def display_incorrect_guesses
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
    @fname = gets.chomp
    yaml = YAML::dump(self)
    saved = File.new("saved/#{@fname}.yaml", "w")
    saved.write(yaml)
    puts "Game saved."
    return true
  end
end

Game.new