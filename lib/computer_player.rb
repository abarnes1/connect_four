# frozen_string_literal: true

# Contains attributes for a computer player that can make random moves
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
