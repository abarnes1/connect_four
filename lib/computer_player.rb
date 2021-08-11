class ComputerPlayer
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def make_choice(columns)
    columns.sample
  end
end