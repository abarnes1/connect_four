require_relative '../lib/connect_game'

describe ConnectGame do
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
