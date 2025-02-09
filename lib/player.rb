class Player
  attr_reader :name

  COLOR_SHORTCUTS = {
    'y' => :yellow,
    'g' => :green,
    'b' => :blue,
    'k' => :black,
    'm' => :magenta,
    'c' => :cyan,
    'r' => :red,
    'w' => :white
  }

  def initialize(name, is_human)
    @name = name
    @is_human = is_human
  end

  def is_human?
    @is_human
  end

  def make_guess
    if is_human?
      prompt_for_guess
    else
      generate_computer_guess
    end
  end

  private

  def prompt_for_guess
    puts "Enter your guess as four colors separated by spaces (e.g., y g b m):"
    puts "Color options: y (yellow), g (green), b (blue), k (black), m (magenta), c (cyan)"

    loop do
      input = gets.chomp.downcase.split.map { |shortcut| COLOR_SHORTCUTS[shortcut] }
      if valid_guess?(input)
        return input
      else
        puts "Invalid input! Please enter exactly four colors from: y (yellow), g (green), b (blue), k (black), m (magenta), c (cyan)"
      end
    end
  end

  def valid_guess?(guess)
    guess.length == Board::CODE_LENGTH && guess.all? { |color| Board::CODE_COLORS.include?(color) }
  end

  def generate_computer_guess
    Board::CODE_COLORS.sample(Board::CODE_LENGTH) # Computer makes random code
  end
end
