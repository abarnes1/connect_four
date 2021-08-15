require_relative '../lib/computer_player'

describe ComputerPlayer do
  describe '#choose_move' do
    subject(:player) { described_class.new(nil, nil) }
    moves = [1, 2, 3]

    context "when #{moves} are available" do
      it 'chooses an available move' do
        actual = player.choose_move(moves)
        expect(moves.include?(actual)).to be(true)
      end
    end

    context "when no moves are available" do
      it 'returns nil' do
        actual = player.choose_move(nil)
        expect(actual).to be_nil
      end
    end
  end
end