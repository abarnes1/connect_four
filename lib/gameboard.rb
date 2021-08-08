require 'pry-byebug'
require_relative 'tokens'

class Gameboard
  def initialize(rows = 6, columns = 7)
    @columns = columns.freeze
    @rows = rows.freeze
    @board = Array.new(@columns * @rows) { Tokens::EMPTY}
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

  def drop(column, piece)
    indices = column_indices(column).reverse
    first_open = indices.find { |index| @board[index] == Tokens::EMPTY }
    @board[first_open] = piece
  end

  private 

  def column_indices(column)
    indices = []

    @rows.times do |row_index|
      indices << column + (row_index * @columns) - 1
    end

    indices
  end
end