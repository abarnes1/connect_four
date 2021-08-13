# frozen_string_literal: true

require_relative 'gameboard'
require_relative 'human_player'
require_relative 'computer_player'

# logic to setup, start, allow moves, and end a connect game
class ConnectGame
  attr_reader :last_token_placed, :current_player

  def initialize(rows = 6, columns = 7, win_length = 4)
    @player1 = nil
    @player2 = nil
    @current_player = nil
    @win_length = win_length
    @gameboard = Gameboard.new(rows, columns)
    @last_token_placed = nil
    @winner = nil
  end

  def last_move_connect_length
    return 0 if @last_token_placed.nil?

    @gameboard.connected_count(@last_token_placed)
  end

  def play_game
    setup_game
    puts @gameboard.to_s
    play_turns

    if @winner.nil?
      puts 'It was a draw :('
    else
      puts "#{@winner.name} #{@winner.token}  wins!"
    end
  end

  def setup_game
    @player1 = create_player('Player 1', Tokens::RED)
    @player2 = create_player('Player 2', Tokens::WHITE)
    @current_player = @player1
    @winner = nil
    @last_token_placed = nil
  end

  def create_player(name, token)
    player_type = ''

    until %w[1 2].include?(player_type)
      puts "Choose a player type for #{name}.\n Enter 1 for Human or 2 for Computer: "
      player_type = gets.chomp
    end

    if player_type.eql?('1')
      HumanPlayer.new(name, token)
    else
      ComputerPlayer.new(name, token)
    end
  end

  def play_turns
    until game_over?
      play_next_turn(@current_player)
      puts @gameboard.to_s

      if game_won?
        @winner = @current_player
        return
      end

      switch_player
    end
  end

  def play_next_turn(current_player)
    input = player_input(current_player)
    @last_token_placed = @gameboard.drop(input, current_player.token)
  end

  def game_over?
    return true if game_won? || @gameboard.full?

    false
  end

  def player_input(current_player)
    column = nil

    until valid_player_input?(column) && valid_move?(column)
      if current_player.instance_of?(HumanPlayer)
        print "Choose a column for #{current_player.name} #{current_player.token} : "
        column = gets.chomp.to_i
      elsif current_player.instance_of?(ComputerPlayer)
        column = @current_player.choose_move(@gameboard.columns.to_a)
        puts "#{current_player.name} (#{current_player.token} ) chooses column ##{column}"
      end
    end

    column
  end

  def game_won?
    last_move_connect_length >= @win_length
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def valid_move?(column)
    column_values = @gameboard.column(column)
    column_values.any?(Tokens::EMPTY) ? true : false
  end

  def valid_player_input?(input)
    count = @gameboard.columns
    return false unless (1..count).include?(input.to_i)

    true
  end

  def to_s
    @gameboard.to_s
  end
end
