class WinChecker
  attr_reader :board

  def initialize(rules, board = nil)
    @board = board
    @rules = rules
  end

  def check_win_from_field(pos_x, pos_y)
    check_horizontally(pos_x, pos_y) || check_vertically(pos_x, pos_y) || check_diagonal(pos_x, pos_y)
  end

  def update_board(board)
    @board = board
  end

  def check
    board.each_with_index do |row, y|
      row.each_with_index do |_, x|
        next if board[y][x].nil?
        return true if check_win_from_field(x, y)
      end
    end
    false
  end

  private

  def check_horizontally(pos_x, pos_y, max = @rules.width)
    symbol = board[pos_y][pos_x]
    max_check_x = pos_x + @rules.winning_count - 1
    return false if symbol.nil? || max_check_x >= max

    (pos_x..max_check_x).each do |pos|
      return false if board[pos_y][pos] != symbol
    end
    symbol
  end

  def check_vertically(pos_x, pos_y)
    symbol = board[pos_y][pos_x]

    max_check_y = pos_y + @rules.winning_count - 1
    return false if max_check_y >= @rules.height

    (pos_y..max_check_y).each do |pos|
      return false if board[pos][pos_x] != symbol
    end
    symbol
  end

  def check_diagonal(pos_x, pos_y)
    symbol = board[pos_y][pos_x]
    return false if pos_y + 2 >= @rules.height

    check_diagonal_right(pos_x, pos_y, symbol) || check_diagonal_left(pos_x, pos_y, symbol)
  end

  def check_diagonal_left(pos_x, pos_y, symbol)
    return false if pos_y + @rules.winning_count - 1 >= @rules.height || pos_x + @rules.winning_count >= @rules.width

    (0..3).each do |num|
      return false if board[pos_x + num][pos_y + num] != symbol
    end
    true
  end

  def check_diagonal_right(pos_x, pos_y, symbol)
    finish_x = pos_x - @rules.winning_count + 1
    finish_y = pos_y + @rules.winning_count - 1

    return false if finish_x.negative? || finish_y >= @rules.height

    (0..3).each do |num|
      return false if board[pos_y + num][pos_x - num] != symbol
    end
    true
  end
end
