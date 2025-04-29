require './lib/tdd_connect_four/player'
describe Player do
  let(:rules) { double('rules', { width: 7 }) }
  let(:board) { double('board') }
  subject(:player) { described_class.new('George', board, rules) }
  before do
    allow(player).to receive(:puts)
  end

  describe '#input_loop' do
    let(:correct_input) { 2 }
    context('when input is wrong 3 times') do
      before do
        allow(player).to receive(:gets).and_return(11, 'p', 0, correct_input)
        allow(player).to receive(:valid_move?).and_return(false, false, false, true)
      end

      it('calls valid_move? 4 times') do
        expect(player).to receive(:valid_move?).exactly(4).times
        player.input_loop(board)
      end

      it('returns correct input value') do
        result = player.input_loop(board)
        expect(result).to be(correct_input - 1)
      end
    end
  end

  describe '#valid_move?' do
    context 'when board is default' do
      before do
        allow(player).to receive(:check_column_free).and_return(true)
      end
      it('returns true for valid move') do
        move_result = player.valid_move?(5, board)
        expect(move_result).to eq(true)
      end

      it('returns false for invalid move') do
        move_result = player.valid_move?(11, board)
        expect(move_result).to eq(false)
      end

      it('returns false for non numeric') do
        move_result = player.valid_move?('as', board)
        expect(move_result).to eq(false)
      end
    end

    context 'when board is almost full' do
      let(:almost_full_board) do
        [[1, nil, 1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1, 1, 1]]
      end
      subject(:player) { described_class.new('George', 'x', rules) }
      it 'returns false for full column' do
        valid = player.valid_move?(5, almost_full_board)
        expect(valid).to be(false)
      end

      it 'returns true for empty column' do
        valid = player.valid_move?(5, almost_full_board)
        expect(valid).to be(false)
      end
    end
  end
end
