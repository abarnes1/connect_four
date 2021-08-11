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
end
