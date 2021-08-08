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

  describe '#empty' do
  end
end