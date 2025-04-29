require './lib/tdd_connect_four/win_checker'

describe WinChecker do
  describe '#check' do
    let(:empty_board) do
      [[nil, nil, nil, nil, nil, nil, nil],
       [nil, nil, nil, nil, nil, nil, nil],
       [nil, nil, nil, nil, nil, nil, nil],
       [nil, nil, nil, nil, nil, nil, nil],
       [nil, nil, nil, nil, nil, nil, nil],
       [nil, nil, nil, nil, nil, nil, nil]]
    end
    let(:rules) { double('rules', { width: 7, height: 6, winning_count: 4 }) }
    subject(:win_checker) { described_class.new(rules, empty_board) }

    context 'when board is empty' do
      it('returns false') do
        result = subject.check
        expect(result).to eq(false)
      end
    end

    context 'when x is winning horizontally' do
      let(:horizntally_winning_board) do
        [[nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, 'x', 'x', 'x', 'x', nil]]
      end

      before do
        allow(win_checker).to receive(:board).and_return(horizntally_winning_board)
      end

      it('returns true') do
        result = win_checker.check
        expect(result).to eq(true)
      end
    end

    context 'when board is full without win' do
      let(:full_board) do
        [%w[x x x o o o x],
         %w[o o o x x x o],
         %w[x x x o o o x],
         %w[o o o x x x o],
         %w[x x x o o o x],
         %w[o o o x x x o]]
      end

      before do
        allow(win_checker).to receive(:board).and_return(full_board)
      end

      it('returns false') do
        result = win_checker.check
        expect(result).to eq(false)
      end
    end

    context 'when x is almost winning horizontally' do
      let(:horizntally_winning_board) do
        [[nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil],
         ['o', 'x', 'x', 'o', 'x', 'x', nil]]
      end

      before do
        allow(win_checker).to receive(:board).and_return(horizntally_winning_board)
      end

      it('returns false') do
        result = win_checker.check
        expect(result).to eq(false)
      end
    end

    context 'when x is winning vertically' do
      let(:vertically_winning_board) do
        [[nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, 'o', nil, nil, nil, nil],
         [nil, nil, 'x', nil, nil, nil, nil],
         [nil, nil, 'x', nil, nil, nil, nil],
         [nil, nil, 'x', nil, nil, nil, nil],
         ['o', 'x', 'x', 'o', 'x', 'x', nil]]
      end

      before do
        allow(win_checker).to receive(:board).and_return(vertically_winning_board)
      end

      it('returns true') do
        result = win_checker.check
        expect(result).to eq(true)
      end
    end

    context 'when x is winning diagonally' do
      let(:diagnal_left_right_win) do
        [['x', nil, nil, nil, nil, nil, nil],
         [nil, 'x', 'o', nil, nil, nil, nil],
         [nil, nil, 'x', nil, nil, nil, nil],
         [nil, nil, 'o', 'x', nil, nil, nil],
         [nil, nil, 'x', nil, nil, nil, nil],
         ['o', 'x', 'x', 'o', 'x', 'x', nil]]
      end

      before do
        allow(win_checker).to receive(:board).and_return(diagnal_left_right_win)
      end
      it('returns true') do
        result = win_checker.check
        expect(result).to eq(true)
      end
    end

    context 'when board x is  winning mid game' do
      let(:mid_game) do
        [
          [nil, nil, nil, nil, nil, nil, nil],

          [nil, nil, nil, nil, nil, nil, nil],

          [nil, nil, nil, 'x', nil, nil, nil],

          [nil, nil, 'x', 'o', nil, nil, nil],

          [nil, 'x', 'x', 'o', nil, nil, nil],

          ['x', 'o', 'o', 'o', 'x', nil, nil]
        ]
      end

      before do
        allow(win_checker).to receive(:board).and_return(mid_game)
      end
      it('returns true') do
        result = win_checker.check
        expect(result).to eq true
      end
    end
  end
end
