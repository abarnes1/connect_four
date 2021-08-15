# frozen_string_literal: true

require_relative 'lib/connect_game'

$stdout.sync = true # allows use of print keep prompt and input on same line

loop do
  game = ConnectGame.new
  game.play_game
  print 'Play again? Enter Y for yes or any other key for no: '
  answer = gets.chomp
  break unless answer.downcase == 'y'
end
