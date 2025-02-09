class Board
  attr_reader :board, :guesses

  CODE_LENGTH = 4 # Constant since it won't change
  MAX_TURNS = 12
  CODE_COLORS = [:yellow, :green, :blue, :black, :magenta, :cyan].freeze
  PLACEHOLDER_COLOR = :light_grey

  def initialize
    reset_board
    @guesses = []
  end

  def current_guess(turn)
    @guesses[turn] || []
  end

  def reset_board
    @board = Array.new(MAX_TURNS) { 
      { guess: Array.new(CODE_LENGTH, PLACEHOLDER_COLOR), 
        check: Array.new(CODE_LENGTH, PLACEHOLDER_COLOR) } }
    #puts "Board after reset: #{@board.inspect}"  # Debugging line to verify structure
  end

  def display_board
    #puts "Current Board:"
    puts " guess  |  check  "
    @board.each_with_index do |row, index|
      #puts "Row #{index}: #{row.inspect}"  # Debugging line to check each row
      guess_part = row[:guess].map { |color| colorize_dot(color) }.join(" ")
      check_part = row[:check].map { |color| colorize_dot(color) }.join(" ")
      puts "#{guess_part.ljust(16)} | #{check_part.ljust(10)}"
    end
  end

  def update_board(turn, guess, check)
    row_index = -(turn + 1) # negative index makes turn 0 fill the last row, turn 1 second last, etc
    @board[row_index][:guess] = guess
    @board[row_index][:check] = check
  end

  private

  def colorize_dot(color)
    color_map = {
      yellow: "\e[33m●\e[0m",   # Yellow
      green: "\e[32m●\e[0m",    # Green
      blue: "\e[34m●\e[0m",     # Blue
      black: "\e[30m●\e[0m",    # Black
      magenta: "\e[35m●\e[0m",  # Magenta
      cyan: "\e[36m●\e[0m",     # Cyan
      red: "\e[31m●\e[0m",      # Feedback Red
      white: "\e[37m●\e[0m",    # Feedback White
      light_grey: "\e[90m●\e[0m" # Placeholder (Empty Peg)
    }

    color_map[color] || "●"  # Default to normal dot if color is missing
  end
end
