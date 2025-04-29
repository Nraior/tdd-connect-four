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
      move = current_player.input_loop(board)
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
end
