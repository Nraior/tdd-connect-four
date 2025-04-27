class Player
  def initialize(name, board, rules = nil)
    @name = name
    @rules = rules
    @board = board
  end

  def input_loop
    good_move = nil
    until !!good_move
      move = get_move
      if valid_move?(move, @rules.max)
        good_move = move
      else
        puts 'Invalid Input'
      end
    end

    good_move
  end

  def valid_move?(move, max = @rules.max)
    return false unless move.is_a? Integer

    move.between?(1, max) && check_column_free(move)
  end

  def check_column_free(input)
    transposed = @board.transpose
    transposed[input][0].nil?
  end

  def get_move
    gets
  end
end
