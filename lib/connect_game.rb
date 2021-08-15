# frozen_string_literal: true

require_relative 'gameboard'
require_relative 'human_player'
require_relative 'computer_player'

# logic to setup, start, allow moves, and end a connect game
class ConnectGame
  attr_reader :current_player, :last_move_identifier

  def initialize(gameboard = nil, win_length = 4)
    @player1 = nil
    @player2 = nil
    @current_player = nil
    @win_length = win_length
    @gameboard = gameboard.nil? ? Gameboard.new : gameboard
    @last_move_identifier = nil
  end

  def end_game
    if game_won?
      puts "#{current_player.name} #{current_player.token} wins!"
    else
      puts 'It was a draw :('
    end
  end

  def last_move_result
    @gameboard.connected_count(@last_move_identifier)
  end

  def play_game
    print_intro
    setup_game
    puts @gameboard.to_s

    play_turns
    end_game
  end

  def setup_game
    @player1 = create_player('Player 1', Tokens::RED)
    @player2 = create_player('Player 2', Tokens::WHITE)
    @current_player = @player1
    @last_move_identifier = nil
  end

  def create_player(name, token)
    player_type = ''

    until %w[1 2].include?(player_type)
      print "Choose a player type for #{name} #{token}\nEnter 1 for Human or 2 for Computer: "
      player_type = gets.chomp
    end

    puts ''

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

      @winner = current_player if game_won?

      switch_player if @winner.nil?
    end
  end

  def play_next_turn(player)
    input = player_input(player)
    @last_move_identifier = @gameboard.drop(input, player.token)
  end

  def game_over?
    return true if game_won? || @gameboard.full?

    false
  end

  def player_input(player)
    column = nil

    until valid_move?(column)
      if player.instance_of?(HumanPlayer)
        print "Choose a column for #{player.name} #{player.token} : "
        column = gets.chomp.to_i
      elsif player.instance_of?(ComputerPlayer)
        sleep(1)
        column = player.choose_move(@gameboard.valid_moves)
        puts "#{player.name} #{player.token}  chooses column ##{column}"
      end
    end

    column
  end

  def game_won?
    last_move_result >= @win_length
  end

  def switch_player
    @current_player = current_player == @player1 ? @player2 : @player1
  end

  def valid_move?(column)
    @gameboard.valid_moves.include?(column)
  end

  def print_intro
    puts "Welcome to Connect #{@win_length}!"
    puts @gameboard.to_s
    puts "\nPlayers will alternate choosing a column to drop their token.  The first to #{@win_length} in a row wins.\n\n"
  end
end
