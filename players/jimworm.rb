module Jimworm # who's just doing this for fun
  def move
    if win_assured? or at_risk?
      [:rest] 
    elsif killable?(opponents.first)
      [:attack, opponents.first]
    else
      [:attack, (rat || opponents.last)]
    end
  end

  def to_s
    "jimworm"
  end
  
  protected
  def win_assured?
    opponents.empty? or (opponents.count < 2 and stats[:experience] >= opponents.sort_by{|p|p.stats[:experience]}.last.stats[:experience])
  end
  
  def at_risk?
    stats[:health] == 100 ? false : stats[:health] <= opponents.last.stats[:health]
  end
  
  def opponents
    Game.world[:players].select{|p| p.to_s != 'rat' and p != self}.sort_by{|p|p.stats[:health]}
  end
  
  def killable?(player)
    stats[:strength] >= player.stats[:health] + (player.stats[:defense] / 2)
  end
  
  def rat
    Game.world[:players].select{|p| p.to_s == 'rat'}.first
  end
end
