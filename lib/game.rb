class Game
  attr_reader :board, :player, :computer
  attr_accessor :player_score, :computer_score, :rounds, :current_round, :codemaker, :codebreaker

  MAX_ROUNDS = 10
  MAX_TURNS = 12

  def initialize
    @board = Board.new
    @player = Player.new("Human", true) # Human player
    @computer = Player.new("Computer", false) # Computer opponent
    @player_score = 0
    @computer_score = 0
    @rounds = choose_rounds
    @current_round = 1
    @codemaker = @computer # Computer starts as codemaker
    @codebreaker = @player
  end

  def choose_rounds
    puts "Enter the number of rounds you want to play (even number, max 10):"
    loop do
      input = gets.chomp.to_i
      return input if input.even? && input > 0 && input <= MAX_ROUNDS

      puts "Invalid input! Please enter an even number between 2 and 10."
    end
  end

  def play
    while @current_round <= @rounds
      puts "\n--- Round #{@current_round} ---"
      start_round
      swap_roles
      @current_round += 1
    end

    declare_winner
  end

  def start_round
    setup = Setup.new(@codemaker) # Codemaker creates a code
    @secret_code = setup.secret_code
    @current_turn = 0
    game_over = false
    guesses_made = 0 # Track the number of guesses made by the codebreaker

    @board.reset_board  # This should reset the board before display
    @board.display_board  # This should be fine after reset

    puts "#{@codemaker.name} is the codemaker. #{@codebreaker.name}, try to guess the code!"

    while @current_turn < MAX_TURNS && !game_over
      puts "\nTurn #{@current_turn + 1}:"
      
      # Human's guess (codebreaker)
      guess = @codebreaker.make_guess
      @board.update_board(@current_turn, guess, Array.new(Board::CODE_LENGTH, Board::PLACEHOLDER_COLOR))
      @board.display_board

      # Provide feedback to the human's guess (codemaker is the computer)
      if @codemaker.is_human?
        # Human is the codemaker, so we need to get feedback from the human
        check = get_feedback_from_human
      else
        # Computer is the codemaker, so use check_guess
        #puts "Computer's guess: #{guess.map { |color| color.to_s[0] }.join(' ')}"  # Display computer's guess
        check = check_guess(guess) # Computer (codemaker) checks the guess
      end

      # Display feedback
      #puts "Feedback on your guess: #{check.count(:red)} red, #{check.count(:white)} white"

      # Update the board with the feedback for this guess
      @board.update_board(@current_turn, guess, check) # Ensure both red and white feedback are passed
      @board.display_board

      # Check if the code has been cracked
      if guess == @secret_code
        puts "The code was guessed correctly!"
        game_over = true
      else
        @current_turn += 1
        guesses_made += 1 # Count the guess made
      end
    end

    # Calculate points for the codemaker
    if @codemaker == @computer
      # Codemaker is the computer
      @computer_score += guesses_made # 1 point for each guess the codebreaker made
      @computer_score += 1 if !game_over # Additional point if the codebreaker didn't guess it
    else
      # Codemaker is the human
      @player_score += guesses_made # 1 point for each guess the codebreaker made
      @player_score += 1 if !game_over # Additional point if the codebreaker didn't guess it
    end

    # Print the score after each round
    puts "\n--- Score after Round #{@current_round} ---"
    puts "#{@player.name}: #{@player_score} points"
    puts "#{@computer.name}: #{@computer_score} points"
  end

  def swap_roles
    @codemaker, @codebreaker = @codebreaker, @codemaker
  end

  def declare_winner
    if @player_score > @computer_score
      puts "\n#{@player.name} wins!"
    elsif @player_score < @computer_score
      puts "\n#{@computer.name} wins!"
    else
      puts "\nIt's a tie!"
    end
  end

  def get_feedback_from_human
    puts "Provide feedback: (r for red, w for white)"
    feedback = gets.chomp.downcase.split("").map do |input|
      case input
      when "r" then :red
      when "w" then :white
      else :light_grey
      end
    end
    feedback
  end

  def check_guess(guess)
    # Computer's feedback logic, based on how the guess compares to the secret code.
    feedback = []
    secret_copy = @secret_code.dup
    guess_copy = guess.dup

    # First pass: Find exact matches (reds)
    guess_copy.each_with_index do |color, index|
      if color == secret_copy[index]
        feedback.push(:red)
        secret_copy[index] = nil # Remove the color from secret_copy
        guess_copy[index] = nil   # Remove the color from guess_copy
      end
    end

    # Second pass: Find color matches (whites)
    guess_copy.each_with_index do |color, index|
      next if color.nil?

      if secret_copy.include?(color)
        feedback.push(:white)
        secret_copy[secret_copy.index(color)] = nil
      end
    end

    feedback
  end
end
