require 'pry-byebug'
require_relative 'tokens'

class Gameboard
  attr_reader :last_index_placed

  def initialize(rows = 6, columns = 7)
    @columns = columns.freeze
    @rows = rows.freeze
    @board = Array.new(@columns * @rows) { Tokens::EMPTY }
    @last_index_placed = nil
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
    column_contents = []
    indices = column_indices(column)

    indices.each do |index|
      column_contents << @board[index]
    end

    column_contents
  end

  def row(row)
    row_contents = []
    indices = row_indices(column)

    indices.each do |index|
      row_contents << @board[index]
    end

    row_contents
  end

  def drop(column, token)
    indices = column_indices(column).reverse
    first_open = indices.find { |index| @board[index] == Tokens::EMPTY }

    @board[first_open] = token
    @last_index_placed = first_open
  end

  def full?
    @board.all? { |token| token != Tokens::EMPTY } 
  end

  def streak_length(index)
    return 0 if @board[index] == Tokens::EMPTY || !index_inbounds?(index)

    directions = [[0, 1], 
                  [1, 0], 
                  [1, 1], 
                  [1, -1]]


    # check left and right
    # check up and down
    # check \ diagonal
    # check / diagonal
  end

  def valid_coord_move?(x, y, start_index)
    return false if x < 0 && column_indices(1).include?(start_index)
    return false if x > 0 && column_indices(@columns).include?(start_index)
    return false if y < 0 && row_indices(1).include?(start_index)
    return false if y > 0 && row_indices(@rows).include?(start_index)

    true
  end

  def coord_to_index(x, y)
    (y * @columns) + x
  end

  def index_to_coord(index)
    [index % @columns, index / @columns]
  end

  def index_after_move(move_coords, index)

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

  def index_in_direction(x, y, start_index)
    new_index = start_index + ()
  end

  def recursive_measure(movement, index, token)
    # base case, not in m
  end

  # def edge_of_row?(index)
  #   row_position = index % @columns
  #   row_end_remainder = @columns - 1
  #   row_start_remainder = 0

  #   [row_start_remainder, row_end_remainder].include? row_position
  # end

  # def edge_of_column?(index)
  #   row_position = index % @columns
  #   row_end_remainder = @columns - 1
  #   row_start_remainder = 0

  #   [row_start_remainder, row_end_remainder].include? row_position
  # end
end

