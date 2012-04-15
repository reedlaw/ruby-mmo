module Flipback
  FATE = 0.7

  def to_s
    "flipback"
  end

  def move
    return [ :rest ] if stats[:health] < 60

    target = dying_player
    if target
      [:attack, target]  
    elsif other_players.count == 1 || rand > FATE || stats[:health] >= 100
      [:attack, best_player]
    else
      [ :rest ]
    end
  end

  private
  def other_players
    Game.world[:players].select{ |p| p != self }
  end

  def best_player
    other_players.sort{ |i,j| i.stats[:experience] <=> j.stats[:experience] }.last
  end

  def dying_player
    other_players.select{ |p| can_kill?(p) }.first
  end

  def can_kill?(player)
    points = stats[:strength] - (player.stats[:defense] / 2)
    player.stats[:health] <= points 
  end
end
