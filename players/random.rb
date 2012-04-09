module RandomPlayer
  def move
    player_count = Game.world[:players].count
    opponent = Game.world[:players].select{|p|p != self}.first
    if opponent && opponent.alive
      [[:rest], [:attack, opponent]][rand(2)]
    else
      [:rest]
    end
  end

  def to_s
    "Crazy Carl"
  end
end
