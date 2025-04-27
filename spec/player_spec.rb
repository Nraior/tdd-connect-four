require './lib/tdd_connect_four/player'
describe Player do
  let(:rules) { double('rules', { max: 7 }) }
  let(:board) { double('board') }
  subject(:player) { described_class.new('George', board, rules) }

  describe '#input_loop' do
    let(:correct_input) { 2 }
    before do
      allow(player).to receive(:puts)
    end
    context('when input is wrong 3 times') do
      before do
        allow(player).to receive(:gets).and_return(11, 'p', 0, correct_input)
        allow(player).to receive(:valid_move?).and_return(false, false, false, true)
      end

      it('calls valid_move? 4 times') do
        expect(player).to receive(:valid_move?).exactly(4).times
        player.input_loop
      end

      it('returns correct input value') do
        result = player.input_loop
        expect(result).to be(correct_input)
      end
    end
  end

  describe '#valid_move?' do
    context 'when board is default' do
      before do
        allow(player).to receive(:check_column_free).and_return(true)
      end
      it('returns true for valid move') do
        move_result = player.valid_move?(5)
        expect(move_result).to eq(true)
      end

      it('returns false for invalid move') do
        move_result = player.valid_move?(11)
        expect(move_result).to eq(false)
      end

      it('returns false for non numeric') do
        move_result = player.valid_move?('as')
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
      subject(:player) { described_class.new('George', almost_full_board, rules) }
      it 'returns false for full column' do
        valid = player.valid_move?(5)
        expect(valid).to be(false)
      end

      it 'returns true for empty column' do
        valid = player.valid_move?(5)
        expect(valid).to be(false)
      end
    end
  end
end
