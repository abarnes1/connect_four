require_relative '../lib/connect_game'
require_relative '../lib/human_player'
require_relative '../lib/computer_player'

describe ConnectGame do
  describe '#create_player' do
    subject(:player_type_game) { described_class.new(6, 7, 4) }

    before do
      allow(player_type_game).to receive(:puts)
    end

    context 'when player type is 1' do
      it 'creates a human player' do
        allow(player_type_game).to receive(:gets).and_return('1')
        player = player_type_game.create_player(nil)

        expect(player).to be_a(HumanPlayer)
      end
    end

    context 'when player type is 2' do
      it 'creates a computer player' do
        allow(player_type_game).to receive(:gets).and_return('2')
        player = player_type_game.create_player(nil)

        expect(player).to be_a(ComputerPlayer)
      end
    end

    context 'when input is invalid' do
      it 'loops until input is valid' do
        allow(player_type_game).to receive(:gets).and_return('57', '', 'aliens', '2')
        player = player_type_game.create_player(nil)

        expect(player).to be_a(ComputerPlayer)
      end
    end
  end

  describe '#game_won?' do
    to_win = 4

    context "when #{to_win} in a row needed for win" do
      subject(:win_test_game) { described_class.new(6, 7, to_win) }

      context "when #{to_win - 1} in a row" do
        it 'has no winner' do
          allow(win_test_game).to receive(:last_move_connect_length).and_return(to_win - 1)

          expect(win_test_game).not_to be_game_won
        end
      end

      context "when #{to_win} in a row" do
        it 'has a winner' do
          allow(win_test_game).to receive(:last_move_connect_length).and_return(to_win)
          expect(win_test_game).to be_game_won
        end
      end

      context "when #{to_win + 1} in a row" do
        it 'has a winner' do
          allow(win_test_game).to receive(:last_move_connect_length).and_return(to_win + 1)

          expect(win_test_game).to be_game_won
        end
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

  describe '#valid_player_input?' do
    subject(:player_input_game) { described_class.new(4, 4, 4) }
    valid_input = '2'
    invalid_input = '9'

    context "when input is within column bounds (#{valid_input})" do
      it 'is valid input' do
        result = player_input_game.valid_player_input?(valid_input)
        expect(result).to eq(true)
      end
    end

    context "when input is outside column bounds (#{invalid_input})" do
      it 'is not valid input' do
        result = player_input_game.valid_player_input?(invalid_input)
        expect(result).to eq(false)
      end
    end
  end

  # describe '#valid_move?' do
  #   subject(:valid_move_game) { described_class.new(2, 2, 2) }
  #   full_column = 1
  #   free_column = 2

  #   before(:all) do
  #     valid_move_game.drop()
  #   end

  #   context 'when column is full' do
  #     it 'is an invalid move' do
        
  #     end
  #   end

  #   context 'when column is not full' do
  #     it 'is a valid move' do
        
  #     end
  #   end
    
  # end
end
