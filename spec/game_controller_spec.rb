require './lib/tdd_connect_four/game_controller'
describe GameController do
  let(:player) { double('player', { symbol: 'x' }) }
  let(:rules) { double('rules', { width: 7, height: 6 }) }
  let(:winner_checker) { double('winner_checker') }
  subject(:controller) { described_class.new(rules, winner_checker) }
  let(:empty_board) do
    [[nil, nil, nil, nil, nil, nil, nil],
     [nil, nil, nil, nil, nil, nil, nil],
     [nil, nil, nil, nil, nil, nil, nil],
     [nil, nil, nil, nil, nil, nil, nil],
     [nil, nil, nil, nil, nil, nil, nil],
     [nil, nil, nil, nil, nil, nil, nil]]
  end

  before do
    allow(player).to receive(:board=)
    allow(player).to receive(:input_loop).and_return(1)
    allow(controller).to receive(:p)
    allow(controller).to receive(:puts)
    allow(winner_checker).to receive(:update_board)
    controller.update_players([player, player])
  end

  describe '#create_board' do
    it 'returns board' do
      board = controller.create_board(6, 7)
      expect(board.flatten.length).to eq(42)
    end
  end

  describe '#prepare_board' do
    it 'updates board' do
      expect { controller.prepare_board }.to change { controller.board.flatten.length }.by(42)
    end

    it 'created board is empty' do
      controller.prepare_board
      expect(controller.board).to eq(empty_board)
    end
  end

  describe '#start_game' do
    before do
      allow(controller).to receive(:game_loop)
    end
    it 'calls prepare_board' do
      expect(controller).to receive(:prepare_board).once
      controller.start_game
    end

    it 'updates @playing' do
      expect { controller.start_game }.to(change { controller.instance_variable_get(:@playing) })
    end
    it 'calls game_loop' do
      expect(controller).to receive(:game_loop).once
      controller.start_game
    end
  end

  describe '#game_loop' do
    before do
      allow(controller).to receive(:playing).and_return(true)
      allow(controller).to receive(:make_move)
      allow(controller).to receive(:handle_draw)
    end
    it 'exits correctly' do
      expect(player).to receive(:input_loop)
      expect(controller).to receive(:check_winner).and_return(false).twice
      expect(controller).to receive(:draw?).and_return(true).twice
      controller.game_loop
    end
  end

  describe '#make_move' do
    before do
      controller.prepare_board
    end
    let(:player) { double('player', { symbol: 'x' }) }
    it 'updates move on first row' do
      controller.make_move(0, player)
      transposed_board = controller.board.transpose
      symbol_count = transposed_board[0].count(player.symbol)
      expect(symbol_count).to eq(1)
    end

    it 'allow second column to have max' do
      10.times do |time|
        controller.make_move(1, player)
      end
      transposed_board = controller.board.transpose
      symbol_count = transposed_board[1].count(player.symbol)
      expect(symbol_count).to eq(6)
    end

    it "doesn't update move on wrong pos" do
      controller.make_move(-1, player)
      flattened = controller.board.flatten
      count = flattened.count(player.symbol)
      expect(count).to eq(0)
    end
  end

  describe '#check_winner' do
    context 'When its empty' do
      it('doesnt send win check command t winner checker') do
        expect(winner_checker).to receive(:check_win_from_field).exactly(0).times
        controller.check_winner
      end
    end

    context 'when there are some fields filled' do
      let(:small_board) do
        [[nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, 'x', 'x', nil, 'x', 'o', nil]]
      end

      before do
        allow(controller).to receive(:board).and_return(small_board)
      end
      it('sends win check commands to winner checker for every non empty field') do
        expect(winner_checker).to receive(:check_win_from_field).exactly(4).times
        controller.check_winner
      end
    end
  end
end
