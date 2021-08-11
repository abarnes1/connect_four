# frozen_string_literal: true

require_relative 'gameboard'
require_relative 'human_player'
require_relative 'computer_player'

# logic to setup, start, allow moves, and end a connect game
class ConnectGame
  attr_reader :last_index_placed

  def initialize(rows, columns, win_length)
    @player1 = nil
    @player2 = nil
    @current_player = nil
    @win_length = win_length
    @gameboard = Gameboard.new(rows, columns)
    @last_index_placed = nil
  end

  def last_move_connect_length
    @gameboard.connected_count(@last_index_placed)
  end

  def create_player(token)
    player_type = ''

    until %w[1 2].include?(player_type)
      puts 'Choose a player type. Enter 1 for Human or 2 for Computer: '
      player_type = gets.chomp
    end

    if player_type.eql?('1')
      HumanPlayer.new(token)
    else
      ComputerPlayer.new(token)
    end
  end

  def game_won?
    return true if last_move_connect_length >= @win_length

    false
  end

  def to_s
    @gameboard.to_s
  end
end
