class Setup
  attr_reader :secret_code

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

  def initialize(codemaker)
    @codemaker = codemaker
    @secret_code = generate_secret_code
  end

  private

  def generate_secret_code
    if @codemaker.is_human?
      prompt_for_secret_code
    else
      Board::CODE_COLORS.sample(Board::CODE_LENGTH).uniq # Picks 4 random colors
    end
  end

  def prompt_for_secret_code
    puts "You are the codemaker! Enter your secret code as four colors separated by spaces (e.g., y g b m):"
    puts "Color options: y (yellow), g (green), b (blue), k (black), m (magenta), c (cyan)"

    loop do
      input = gets.chomp.downcase.split.map { |shortcut| COLOR_SHORTCUTS[shortcut] }
      if valid_code?(input)
        return input
      else
        puts "Invalid input! Please enter exactly four colors from: y (yellow), g (green), b (blue), k (black), m (magenta), c (cyan)"
      end
    end
  end

  def valid_code?(code)
    code.length == Board::CODE_LENGTH && 
      code.all? { |color| Board::CODE_COLORS.include?(color) } &&
      code.uniq.length == code.length  # Ensure no duplicates
  end
end
