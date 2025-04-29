class BoardPresenter
  def self.present(board)
    board.each do |row|
      p row
      puts ''
    end
  end
end
