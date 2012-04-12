module Unpredictable
  def move
    player_count = Game.world[:players].select{|p| (p != self) && p.alive}.count
    if rand(2) > 0 && player_count > 0
      opponent = Game.world[:players].select{|p| (p != self) && p.alive }[rand(player_count)]
      [:attack, opponent]
    else
      [:rest]
    end
  end
  
  def to_s
    "Raiko"
  end
end