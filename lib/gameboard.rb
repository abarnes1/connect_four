require 'pry-byebug'
require_relative 'tokens'

# contains game rows and columns, their boundaries, and allows tokens to be placed
class Gameboard
  attr_reader :last_move_index, :columns

  def initialize(rows = 6, columns = 7)
    @columns = columns.freeze
    @rows = rows.freeze
    @board = Array.new(@columns * @rows) { Tokens::EMPTY }
  end

  def to_s
    output = ''
    row_count = @board.size / @columns

    row_count.times do |row_number|
      row_start_index = (row_number * @columns)
      row = @board.slice(row_start_index, @columns)
      output += "#{row.join(' ')}\n"
    end

    output
  end

  def column(column)
    indices = column_indices(column)
    indices.map { |index| @board[index] }
  end

  def drop(column, token)
    indices = column_indices(column).reverse
    first_open = indices.find { |index| @board[index] == Tokens::EMPTY }

    @board[first_open] = token

    first_open
  end

  def column_full?(column)
    column_tokens = column(column)
    column_tokens.any?
  end

  def full?
    @board.all? { |token| token != Tokens::EMPTY }
  end

  def connected_count(index)
    return 0 if @board[index] == Tokens::EMPTY || !index_inbounds?(index)

    highest_streak = 1
    match_token = @board[index]

    xy_movements = [[0, 1], [1, 0], [1, 1], [1, -1]]

    xy_movements.each do |single_move|
      opposite_move = single_move.map { |move| move * -1 }

      streak = 1 + measure_repeat(single_move, index, match_token) + measure_repeat(opposite_move, index, match_token)
      highest_streak = streak if streak > highest_streak
    end

    highest_streak
  end

  def valid_coord_move?(x_move, y_move, start_index)
    return false if x_move.negative? && column_indices(1).include?(start_index)
    return false if x_move.positive? && column_indices(@columns).include?(start_index)
    return false if y_move.negative? && row_indices(1).include?(start_index)
    return false if y_move.positive? && row_indices(@rows).include?(start_index)

    true
  end

  def coord_to_index(x_coord, y_coord)
    return nil unless x_coord.between?(0, @columns - 1) && y_coord.between?(0, @rows - 1)

    (y_coord * @columns) + x_coord
  end

  def index_to_coord(index)
    return nil unless index_inbounds?(index)

    [index % @columns, index / @columns]
  end

  private

  def column_indices(column)
    indices = []

    @rows.times do |row_index|
      indices << (row_index * @columns) + column - 1
    end

    indices
  end

  def row_indices(row)
    indices = []

    @columns.times do |col_index|
      indices << ((row - 1) * @columns) + col_index
    end

    indices
  end

  def index_inbounds?(index)
    max_index = @board.size - 1
    index.between?(0, max_index)
  end

  def measure_repeat(move, index, token)
    return 0 unless valid_coord_move?(move[0], move[1], index)

    coord = index_to_coord(index)
    coord[0] += move[0]
    coord[1] += move[1]
    new_index = coord_to_index(coord[0], coord[1])

    return 0 if @board[new_index] != token

    1 + measure_repeat(move, new_index, token)
  end
end
