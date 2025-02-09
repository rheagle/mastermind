class ComputerLogic
  attr_reader :board, :secret_code

  def initialize(board, secret_code)
    @board = board
    @secret_code = secret_code
  end

  def make_guess(previous_guess, feedback)
    # If the previous guess exists, refine the next guess
    if feedback
      # Implement logic to adjust the guess based on the feedback
      # For now, let's assume it makes a random guess
      return random_guess
    else
      return random_guess
    end
  end

  def random_guess
    # Generate a random guess from the available color options
    [:yellow, :green, :blue, :magenta, :light_red, :light_yellow].sample(4)
  end
end
