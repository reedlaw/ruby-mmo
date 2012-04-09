module Tough
  def move
    player_count = Game.world[:players].count
    opponent = Game.world[:players].select{|p|p != self}[rand(player_count - 1)]
    if opponent && opponent.alive
      [:attack, opponent]
    else
      [:rest]
    end
  end

  def to_s
    "Sir Samsonite"
  end
end
