class GameController
  attr_reader :board, :playing

  def initialize(players, rules)
    @rules = rules
    @players = players
    @board = []
    @playing = false
    @tour = 0
  end

  def start_game
    @playing = true
    prepare_board
    game_loop
  end

  def create_board(width, height)
    Array.new(height) { Array.new(width) { nil } }
  end

  def prepare_board
    @board = create_board(@rules.width, @rules.height)
    @players.each do |player|
      player.board = @board
    end
  end

  def game_loop
    while playing
      move = current_player.input_loop
      make_move(move, current_player)
      break if check_winner || draw?
    end

    if check_winner
      handle_win
    elsif handle_draw
      handle_draw
    end
  end

  def handle_win
    @playing = false
    puts 'You win!'
  end

  def handle_draw
    @playing = false
    puts 'Draw!'
  end

  def check_winner
    board.each_with_index do |row, y|
      row.each_with_index do |column, x|
        next if board[y][x].nil?
        return true if check_win_from_field(x, y)
      end
    end
    false
  end

  def make_move(move, player)
    return false if move.negative? || move >= board.length

    transposed_board = board.transpose
    last_found_nil_index = transposed_board[move].reverse.find_index(nil)
    return false if last_found_nil_index.nil?

    row_index = transposed_board[move].length - last_found_nil_index - 1
    @board[row_index][move] = player.symbol
  end

  def draw?
    board.flatten.count(nil) <= 0
  end

  private

  def current_player
    @players[@tour % 2]
  end

  def check_win_from_field(pos_x, pos_y)
    check_horizontally(pos_x, pos_y) || check_vertically(pos_x, pos_y) || check_diagonal(pos_x, pos_y)
  end

  def check_horizontally(pos_x, pos_y, max = @rules.width)
    symbol = board[pos_y][pos_x]
    min_check_x = pos_x - 1
    max_check_x = pos_x + 2
    return false if symbol.nil? || max_check_x >= max || min_check_x.negative?

    (min_check_x..max_check_x).each do |pos|
      return false if board[pos_y][pos] != symbol
    end
    symbol
  end

  def check_vertically(pos_x, pos_y)
    symbol = board[pos_y][pos_x]

    min_check_y = pos_y - 1
    max_check_y = pos_y + 2
    return false if max_check_y >= @rules.height || min_check_y.negative?

    (min_check_y..max_check_y).each do |pos|
      return false if board[pos][pos_x] != symbol
    end
    symbol
  end

  def check_diagonal(pos_x, pos_y)
    symbol = board[pos_y][pos_x]
    first_y = pos_y - 1
    first_x = pos_x - 1
    finish_y = pos_y + 2
    finish_x = pos_x + 2

    left = true
    right = true
    return false if first_y.negative? || first_x.negative? || finish_y >= @rules.height || finish_x >= @rules.width

    (first_x..finish_x).each do |num|
      if board[num][num] != symbol
        left = false
        break
      end
    end

    # right
    (first_x..finish_x).each_with_index do |num, index|
      if board[num][finish_x - num] != symbol
        right = false
        break
      end
    end
    left || right
  end
end
