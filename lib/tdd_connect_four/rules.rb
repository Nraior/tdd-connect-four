class Rules
  attr_reader :width, :height, :winning_count

  def initialize(width, height, winning_count = 4)
    @width = width
    @height = height
    @winning_count = winning_count
  end
end
