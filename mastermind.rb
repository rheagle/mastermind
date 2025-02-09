require "bundler/setup"
Bundler.require(:default)

# Load all Ruby files in the lib directory
Dir["#{__dir__}/lib/**/*.rb"].each { |file| require file }

#puts "Your program is running..."
game = Game.new
game.play