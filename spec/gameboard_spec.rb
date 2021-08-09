require_relative '../lib/gameboard'

describe Gameboard do
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

  describe '#last_index_placed' do
    subject(:last_placed_game) { described_class.new(2, 2) }

    context 'when dropped in col 1 of 2x2' do
      it 'returns index 2 on first drop' do
        last_placed_game.drop(1, 'X')
        last_index = last_placed_game.last_index_placed

        expect(last_index).to eq(2)
      end

      it 'returns index 0 on second drop' do
        last_placed_game.drop(1, 'X')
        last_placed_game.drop(1, 'X')
        last_index = last_placed_game.last_index_placed

        expect(last_index).to eq(0)
      end
    end
  end

  describe '#streak_length' do
    context 'when index has no token' do
      subject(:none_in_row) { described_class.new(2, 2) }

      context 'when checking empty index' do
        it 'returns 0' do
          expect(none_in_row.streak_length(0)).to be_zero
        end
      end
  
      context 'when checking out of bounds index' do
        it 'returns 0' do
          expect(none_in_row.streak_length(100)).to be_zero
        end
      end
    end
  end

  describe '#valid_coord_move?' do
    subject(:coord_test_game) { described_class.new }

    context 'when moving inside the board' do

      it 'is a valid move' do
        valid = coord_test_game.valid_coord_move?(1, 1, 0)
        expect(valid).to eq(true)
      end
    end

    context 'when movement is out of bounds' do
      context 'when left boundary broken' do
        it 'is not a valid move' do
          x_move = -1
          y_move = 1
          left_column_index = 7
          valid = coord_test_game.valid_coord_move?(x_move, y_move, left_column_index)
          expect(valid).to eq(false)
        end
      end

      context 'when right boundary broken' do
        it 'is not a valid move' do
          x_move = 1
          y_move = 0
          right_column_index = 27
          valid = coord_test_game.valid_coord_move?(x_move, y_move, right_column_index)
          expect(valid).to eq(false)
        end
      end

      context 'when top boundary broken' do
        it 'is not a valid move' do
          x_move = 0
          y_move = -1
          top_row_index = 5
          valid = coord_test_game.valid_coord_move?(x_move, y_move, top_row_index)
          expect(valid).to eq(false)
        end
      end

      context 'when bottom boundary broken' do
        it 'is not a valid move' do
          x_move = 0
          y_move = 1
          bottom_row_index = 40
          valid = coord_test_game.valid_coord_move?(x_move, y_move, bottom_row_index)
          expect(valid).to eq(false)
        end
      end
    end
  end
end