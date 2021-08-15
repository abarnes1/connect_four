module GameboardPrinter
  def to_s
    output = "#{display_header_footer}\n"
    row_count = @board.size / @columns

    row_count.times do |row_number|
      row_start_index = (row_number * @columns)
      row = @board.slice(row_start_index, @columns)
      output += "| #{row.join(' ')}  |\n"
    end

    output += display_header_footer

    output += "\n  #{column_selectors}"
  end

  def display_header_footer
    '=' * (2 * (@columns + 2))
  end

  def column_selectors
    output = ''
    @columns.times do |index|
      output += "#{index + 1} "
    end

    output
  end
end