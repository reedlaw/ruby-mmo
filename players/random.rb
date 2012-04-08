module RandomPlayer
  def move
    [[:trade, 2], [:travel, 3]][rand(2)]
  end

  def to_s
    "Crazy Carl"
  end
end
