require './lib/tdd_connect_four/player'
describe Player do
  let(:rules) { double('rules', { max: 7 }) }
  subject(:player) { described_class.new('George', rules) }

  describe '#input_loop' do
    let(:correct_input) { 2 }
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
    xit('returns true for valid move') do
      move_result = player.valid_move?(5)
      expect(move_result).to eq(true)
    end

    xit('returns false for invalid move') do
      move_result = player.valid_move?(11)
      expect(move_result).to eq(false)
    end

    xit('returns false for non numeric') do
      move_result = player.valid_move?('as')
      expect(move_result).to eq(false)
    end
  end
end
