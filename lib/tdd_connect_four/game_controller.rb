require_relative './board_presenter'
class GameController
  attr_reader :board, :playing

  def initialize(rules, win_checker)
    @rules = rules
    @players = []
    @board = []
    @playing = false
    @tour = 0
    @winning_count = 4
    @win_checker = win_checker
  end

  def update_players(players)
    @players = players
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
    @win_checker.update_board(@board)
    @players.each do |player|
      player.board = @board
    end
  end

  def game_loop
    while playing
      puts 'Playing!'
      BoardPresenter.present(board)
      move = current_player.input_loop
      make_move(move, current_player)
      break if check_winner || draw?

      @tour += 1
    end

    if check_winner
      handle_win
    elsif draw?
      handle_draw
    end
  end

  def handle_win
    @playing = false
    BoardPresenter.present(@board)
    puts "#{current_player.name} wins!"
  end

  def handle_draw
    @playing = false
    puts 'Draw!'
  end

  def check_winner
    @win_checker.check
  end

  def make_move(move, player)
    return false if move.negative? || move >= board[0].length

    puts "make move #{move}"

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
    max_check_x = pos_x + @winning_count - 1
    return false if symbol.nil? || max_check_x >= max

    (pos_x..max_check_x).each do |pos|
      return false if board[pos_y][pos] != symbol
    end
    symbol
  end

  def check_vertically(pos_x, pos_y)
    symbol = board[pos_y][pos_x]

    max_check_y = pos_y + @winning_count - 1
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
    return false if pos_y + @winning_count - 1 >= @rules.height || pos_x + @winning_count >= @rules.width

    (0..3).each do |num|
      return false if board[pos_x + num][pos_y + num] != symbol
    end
    true
  end

  def check_diagonal_right(pos_x, pos_y, symbol)
    finish_x = pos_x - @winning_count + 1
    finish_y = pos_y + @winning_count - 1

    return false if finish_x.negative? || finish_y >= @rules.height

    (0..3).each do |num|
      return false if board[pos_y + num][pos_x - num] != symbol
    end
    true
  end
end
