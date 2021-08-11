require_relative '../lib/gameboard'

describe Gameboard do
  context '#all_columns' do
    subject(:all_columns_game) { described_class.new(6, 7) }

    context 'when game has 7 columns' do
      it 'returns 7 columns' do
        count = all_columns_game.all_columns.size
        expect(count).to eq(7)
      end
    end

    context 'when token dropped in column 2' do
      it 'returns columns in correct order' do
        columns = all_columns_game.all_columns

        expect(columns[1]).not_to be_empty
      end
    end
  end

  describe '#connected_count' do
    context 'when index has no token' do
      subject(:none_in_row) { described_class.new(2, 2) }

      context 'when checking empty index' do
        it 'returns 0' do
          expect(none_in_row.connected_count(0)).to be_zero
        end
      end

      context 'when checking out of bounds index' do
        it 'returns 0' do
          expect(none_in_row.connected_count(100)).to be_zero
        end
      end
    end

    context 'when single token' do
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

  describe '#coord_to_index' do
    subject(:coord_game) { described_class.new }

    context 'coord is out of bounds' do
      invalid_x = -1
      invalid_y = 10
      valid_x = 1
      valid_y = 1

      it "returns nil when x-coord is invalid (#{invalid_x})" do
        valid = coord_game.coord_to_index(invalid_x, valid_y)
        expect(valid).to be_nil
      end

      it "returns nil when y-coord is invalid (#{invalid_y})" do
        valid = coord_game.coord_to_index(valid_x, invalid_y)
        expect(valid).to be_nil
      end
    end

    context 'coord is in bounds' do
      valid_x = 3
      valid_y = 3
      correct_index = 24

      it "returns #{correct_index} for coord [#{valid_x}, #{valid_y}]" do
        actual = coord_game.coord_to_index(valid_x, valid_y)
        expect(actual).to eq(correct_index)
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

  describe '#last_drop_index' do
    subject(:last_placed_game) { described_class.new(2, 2) }

    context 'when dropped in col 1 of 2x2' do
      it 'returns index 2 on first drop' do
        last_placed_game.drop(1, 'X')
        last_index = last_placed_game.last_drop_index

        expect(last_index).to eq(2)
      end

      it 'returns index 0 on second drop' do
        last_placed_game.drop(1, 'X')
        last_placed_game.drop(1, 'X')
        last_index = last_placed_game.last_drop_index

        expect(last_index).to eq(0)
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
