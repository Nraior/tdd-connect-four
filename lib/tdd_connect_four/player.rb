class Player
  def initialize(name, rules = nil)
    @name = name
    @rules = rules
  end

  def input_loop
    good_move = nil
    until !!good_move
      move = get_move
      good_move = move if valid_move?(move)
    end

    good_move
  end

  def valid_move?(move, rules = @rules)
    return false unless move.is_a? Integer

    move.between?(1, rules.max)
  end

  def get_move
    gets
  end
end
