# frozen_string_literal: true

# Object that contains attributes for a human player
class HumanPlayer
  attr_reader :token, :name

  def initialize(name, token)
    @token = token
    @name = name
  end
end
