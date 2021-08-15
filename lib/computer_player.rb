class ComputerPlayer
  attr_reader :token, :name

  def initialize(name, token)
    @token = token
    @name = name
  end

  def choose_move(choices)
    return nil if choices.nil?
    
    choices.sample
  end
end