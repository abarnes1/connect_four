require_relative '../lib/gameboard'

describe Gameboard do
  describe '#column_full?' do
    context 'when game is 2x2' do
      subject(:full_column_game) { described_class.new(2, 2) }

      context 'when column 1 has 2 dropped tokens' do
        it 'is a full column' do
          full_column_game.drop(1, 'X')
          full_column_game.drop(1, 'X')

          expect(full_column_game.column_full?(1)).to eq(true)
        end
      end

      context 'when column 1 has 1 dropped tokens' do
        it 'is not a full column' do
          full_column_game.drop(1, 'X')

          expect(full_column_game.column_full?(1)).to eq(false)
        end
      end
    end
  end

  describe '#connected_count' do
    context 'when identifier parameter passed' do
      context 'when checking empty index' do
        subject(:empty_index_board) { described_class.new(2, 2) }

        it 'returns 0' do
          expect(empty_index_board.connected_count(0)).to be_zero
        end
      end

      context 'when checking out of bounds index' do
        subject(:out_of_bounds_board) { described_class.new(2, 2) }

        it 'returns 0' do
          expect(out_of_bounds_board.connected_count(100)).to be_zero
        end
      end

      context 'when single token dropped' do
        subject(:single_drop_game) { described_class.new }

        it 'returns streak of 1' do
          index_to_check = single_drop_game.drop(3, 'X')
          connected = single_drop_game.connected_count(index_to_check)

          expect(connected).to eq(1)
        end
      end

      context 'when 3 in a row horizontal' do
        subject(:row_drop_game) { described_class.new }

        it 'returns streak of 3' do
          row_drop_game.drop(1, 'X')
          row_drop_game.drop(2, 'X')

          index_to_check = row_drop_game.drop(3, 'X')
          connected = row_drop_game.connected_count(index_to_check)

          expect(connected).to eq(3)
        end
      end

      context 'when 3 in a row vertical' do
        subject(:column_drop_game) { described_class.new }

        it 'returns streak of 3' do
          column_drop_game.drop(3, 'X')
          column_drop_game.drop(3, 'X')
          index_to_check = column_drop_game.drop(3, 'X')

          connected = column_drop_game.connected_count(index_to_check)

          expect(connected).to eq(3)
        end
      end

      context 'when 3 in a row diagonal' do
        subject(:diagonal_drop_game) { described_class.new }

        it 'returns streak of 3' do
          diagonal_drop_game.drop(1, 'X')

          diagonal_drop_game.drop(2, '')
          diagonal_drop_game.drop(2, 'X')

          diagonal_drop_game.drop(3, '')
          diagonal_drop_game.drop(3, '')
          index_to_check = diagonal_drop_game.drop(3, 'X')

          connected = diagonal_drop_game.connected_count(index_to_check)

          expect(connected).to eq(3)
        end
      end
    end

    context 'when identifier parameter is not passed' do
      subject(:highest_not_last_move) { described_class.new(2, 2) }

      it 'checks the whole board for highest possible result' do
        highest_not_last_move.drop(1, 'X')
        highest_not_last_move.drop(2, 'X')
        highest_not_last_move.drop(1, 'O')

        connected = highest_not_last_move.connected_count

        expect(connected).to eq(2)
      end
    end
  end

  describe '#drop' do
    column_number = 3
    token = 'O'

    context "when one token dropped in column #{column_number}" do
      subject(:single_drop_game) { described_class.new }

      before do
        single_drop_game.drop(column_number, token)
      end

      it "lands in column #{column_number}" do
        column = single_drop_game.column(column_number)
        expect(column.any?(token)).to eq(true)
      end

      it 'falls to the lowest space' do
        column = single_drop_game.column(column_number)
        expect(column.last).to eq(token)
      end
    end

    context "when two tokens dropped in column #{column_number}" do
      subject(:multi_drop_game) { described_class.new }

      before do
        multi_drop_game.drop(column_number, token)
        multi_drop_game.drop(column_number, token)
      end

      it 'falls to the lowest two spaces' do
        column = multi_drop_game.column(column_number)
        last_two = column[-2..-1]
        expect(last_two.all?(token)).to eq(true)
      end
    end
  end

  describe '#full?' do
    context 'when 1 spot filled' do
      subject(:unfilled_game) { described_class.new(2, 1) }

      it 'is not full' do
        unfilled_game.drop(1, 'X')

        expect(unfilled_game).to_not be_full
      end
    end

    context 'when all spots filled' do
      subject(:filled_game) { described_class.new(2, 1) }

      it 'is full' do
        filled_game.drop(1, 'X')
        filled_game.drop(1, 'X')

        expect(filled_game).to be_full
      end
    end
  end
end
