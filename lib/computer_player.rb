class ComputerPlayer
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def choose_move(choices)
    choices.sample
  end
end