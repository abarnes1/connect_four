class Tokens
  self::EMPTY = "\u25CB".freeze
  self::WHITE = "\u25CF".freeze
  # self::RED = "\u25CF".freeze
  self::RED = "\e[31m\u25CF\e[0m".freeze
end