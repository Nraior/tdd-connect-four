class Player
  attr_writer :board
  attr_reader :symbol, :name

  def initialize(name, symbol, rules = nil)
    @name = name
    @rules = rules
    @symbol = symbol
  end

  def input_loop
    good_move = nil
    until !!good_move
      move = get_move.to_i
      if valid_move?(move, @rules.width)
        good_move = move
      else
        puts 'Invalid Input'
      end
    end

    good_move - 1
  end

  def valid_move?(move, max = @rules.max)
    return false unless move.is_a? Integer

    move.between?(1, max) && check_column_free(move - 1)
  end

  def check_column_free(input)
    transposed = @board.transpose
    puts "input #{input}"
    transposed[input][0].nil?
  end

  def get_move
    gets
  end
end
