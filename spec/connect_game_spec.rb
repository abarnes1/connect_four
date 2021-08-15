require_relative '../lib/connect_game'
require_relative '../lib/human_player'
require_relative '../lib/computer_player'

describe ConnectGame do
  describe '#create_player' do
    subject(:player_type_game) { described_class.new }

    before do
      allow(player_type_game).to receive(:puts)
    end

    context 'when player type is 1' do
      it 'creates a human player' do
        allow(player_type_game).to receive(:gets).and_return('1')
        player = player_type_game.create_player(nil, nil)

        expect(player).to be_a(HumanPlayer)
      end
    end

    context 'when player type is 2' do
      it 'creates a computer player' do
        allow(player_type_game).to receive(:gets).and_return('2')
        player = player_type_game.create_player(nil, nil)

        expect(player).to be_a(ComputerPlayer)
      end
    end

    context 'when input is invalid' do
      it 'loops until input is valid' do
        allow(player_type_game).to receive(:gets).and_return('57', '', 'aliens', '2')
        player = player_type_game.create_player(nil, nil)

        expect(player).to be_a(ComputerPlayer)
      end
    end
  end

  describe '#end_game' do
    context 'when there is a winner' do
      subject(:won_game) { described_class.new }
      let(:winning_player) { double('player', name: 'Person', token: 'X') }

      it 'declares the current player as winner' do
        allow(won_game).to receive(:game_won?).and_return(true)
        allow(won_game).to receive(:current_player).and_return(winning_player)
        message = "#{winning_player.name} #{winning_player.token} wins!"
        expect($stdout).to receive(:puts).with(message)
        won_game.end_game
      end
    end

    context 'when there is no winner' do
      subject(:draw_game) { described_class.new }

      it 'declares the game a draw' do
        allow(draw_game).to receive(:game_won?).and_return(false)
        message = 'It was a draw :('
        expect($stdout).to receive(:puts).with(message)
        draw_game.end_game
      end
    end
  end

  describe '#game_over?' do
    context 'when we have a winner' do
      subject(:winner_game) { described_class.new }

      it 'is game over' do
        allow(winner_game).to receive(:game_won?).and_return(true)
        expect(winner_game).to be_game_over
      end
    end

    context 'when we have no winner' do
      let(:no_winner_board) { double('gameboard') }
      subject(:no_winner_game) { described_class.new(no_winner_board, nil) }

      before do
        allow(no_winner_game).to receive(:game_won?).and_return(false)
      end

      context 'when board is full' do
        it 'is game over' do
          allow(no_winner_board).to receive(:full?).and_return(true)
          expect(no_winner_game).to be_game_over
        end
      end

      context 'when board is not full' do
        it 'is not game over' do
          allow(no_winner_board).to receive(:full?).and_return(false)
          expect(no_winner_game).not_to be_game_over
        end
      end
    end
  end

  describe '#game_won?' do
    to_win = 4

    context "when #{to_win} in a row needed for win" do
      subject(:win_test_game) { described_class.new(nil, to_win) }

      context "when #{to_win - 1} in a row" do
        it 'has no winner' do
          allow(win_test_game).to receive(:last_move_result).and_return(to_win - 1)

          expect(win_test_game).not_to be_game_won
        end
      end

      context "when #{to_win} in a row" do
        it 'has a winner' do
          allow(win_test_game).to receive(:last_move_result).and_return(to_win)
          expect(win_test_game).to be_game_won
        end
      end

      context "when #{to_win + 1} in a row" do
        it 'has a winner' do
          allow(win_test_game).to receive(:last_move_result).and_return(to_win + 1)

          expect(win_test_game).to be_game_won
        end
      end
    end
  end

  describe '#last_move_result' do
    let(:test_board) { double('gameboard') }
    subject(:last_move_game) { described_class.new(test_board, nil) }

    context 'when last move is nil' do
      it 'returns 0 in a row' do
        allow(test_board).to receive(:connected_count).and_return(0)
        actual = last_move_game.last_move_result
        expect(actual).to be_zero
      end
    end

    context 'when last move is not nil' do
      it 'it returns at least 1' do
        allow(test_board).to receive(:connected_count).and_return(0)
        actual = last_move_game.last_move_result
        expect(actual).not_to be_positive
      end
    end
  end

  describe '#play_game' do
    subject(:played_game) { described_class.new }

    context 'when game is played' do
      before do
        allow(played_game).to receive(:setup_game)
        allow(played_game).to receive(:puts)
        allow(played_game).to receive(:play_turns)
        allow(played_game).to receive(:end_game)        
      end

      it 'calls #setup_game once' do
        expect(played_game).to receive(:setup_game).once
        played_game.play_game
      end

      it 'calls #play_turns once' do
        expect(played_game).to receive(:play_turns).once
        played_game.play_game
      end

      it 'calls #end_game once' do
        expect(played_game).to receive(:end_game).once
        played_game.play_game
      end
    end
  end

  describe '#play_next_turn' do
    let(:next_turn_board) { double('gameboard') }
    let(:player) { double('player', name: '', token: '') }
    subject(:next_turn_game) { described_class.new(next_turn_board, nil) }

    context 'when token is dropped' do
      it 'sets the last move identifier' do
        input = 1
        expected = 10
        allow(next_turn_game).to receive(:player_input).and_return(input)
        allow(next_turn_board).to receive(:drop).and_return(expected)
        actual = next_turn_game.play_next_turn(player)
        expect(actual).to eq(expected)
      end
    end
  end

  describe '#play_turns' do
    context "when game is over" do
      subject(:no_turn_win) { described_class.new }

      before do
        allow(no_turn_win).to receive(:game_over?).and_return(true)
        allow(no_turn_win).to receive(:play_next_turn)
      end

      it 'does not enter loop' do
        expect(no_turn_win).not_to receive(:switch_player)
      end
    end

    context "when game is over after 2 turns" do
      subject(:two_turn_win) { described_class.new }

      before do
        allow(two_turn_win).to receive(:game_over?).and_return(false, false, true)
        allow(two_turn_win).to receive(:play_next_turn)
        allow(two_turn_win).to receive(:puts)
        allow(two_turn_win).to receive(:switch_player)
      end

      it 'exits the turns loop' do
        expect(two_turn_win).to receive(:play_next_turn).twice
        two_turn_win.play_turns
      end
    end
  end

  describe '#player_input' do
    context 'when player is human' do
      subject(:human_input_test) { described_class.new }
      let(:human_player) { double('human', name: '', token: '') }

      before do
        allow(human_input_test).to receive(:print)
        allow(human_input_test).to receive(:puts)
        allow(human_player).to receive(:instance_of?).and_return(true)
      end

      context 'when first input is valid' do
        before do
          valid_input = '1'
          allow(human_input_test).to receive(:gets).and_return(valid_input)
        end

        it 'exits the loop' do
          expect(human_input_test).to receive(:print).once

          human_input_test.player_input(human_player)
        end
      end

      context 'when input is invalid twice then valid' do
        before do
          invalid_one = ''
          invalid_two = '4000'
          valid_input = '1'

          allow(human_input_test).to receive(:gets).and_return(invalid_one, invalid_two, valid_input)
        end

        it 'loops three times before exiting' do
          expect(human_input_test).to receive(:print).exactly(3).times

          human_input_test.player_input(human_player)
        end
      end
    end

    context 'when player is computer' do
      subject(:computer_input_game) { described_class.new }
      let(:computer_player) { double('computer', name: '', token: '', choose_move: 1) }

      before do
        allow(computer_input_game).to receive(:print)
        allow(computer_input_game).to receive(:puts)
        allow(computer_input_game).to receive(:gets)
        allow(computer_player).to receive(:instance_of?).and_return(false, true)
      end

      context 'when input is valid' do
        it 'it exits the loop' do
          expect(computer_input_game).to receive(:puts).once

          computer_input_game.player_input(computer_player)
        end
      end
    end
  end

  describe '#setup_game' do
    context 'when game is setup' do
      subject(:new_game) { described_class.new }
      let(:player_one) { double('player1') }
      let(:player_two) { double('player2') }

      it 'creates two players' do
        allow(new_game).to receive(:create_player)
        expect(new_game).to receive(:create_player).twice
        new_game.setup_game
      end

      it 'sets the current player to player one' do
        allow(new_game).to receive(:create_player).and_return(player_one, player_two)
        new_game.setup_game
        expect(new_game.current_player).to eq(player_one)
      end

      it 'has no winner' do
        allow(new_game).to receive(:create_player)
        expect(new_game).not_to be_game_won
      end

      it 'has no last move identifier' do
        allow(new_game).to receive(:create_player)
        expect(new_game.last_move_identifier).to be_nil
      end
    end
  end

  describe '#switch_player' do
    subject(:active_player_game) { described_class.new }
    let(:player_one) { double('player_one') }
    let(:player_two) { double('player_two') }

    before do
      allow(active_player_game).to receive(:create_player).and_return(player_one, player_two)
    end

    context 'when player 1 is active' do
      it 'switches to player 2' do
        expected = player_two
        active_player_game.setup_game
        actual = active_player_game.switch_player

        expect(actual).to be(expected)
      end
    end

    context 'when player 2 is active' do
      it 'switches to player 1' do
        expected = player_one
        active_player_game.setup_game
        active_player_game.switch_player
        actual = active_player_game.switch_player

        expect(actual).to be(expected)
      end
    end
  end

  describe '#valid_move?' do
    subject(:player_input_game) { described_class.new }
    valid_input = 2
    invalid_input = 9

    context "when input is within column bounds (#{valid_input})" do
      it 'is valid input' do
        actual = player_input_game.valid_move?(valid_input)
        expect(actual).to eq(true)
      end
    end

    context "when input is outside column bounds (#{invalid_input})" do
      it 'is not valid input' do
        actual = player_input_game.valid_move?(invalid_input)
        expect(actual).to eq(false)
      end
    end
  end
end
