module Jayaram
  def find_max_damage
	list_opponents.sort_by{ |a| [a.stats[:defense],a.stats[:health]]}.last
  end
  
  def find_killable_opponent
	opponents = list_opponents
	opponents.select {|op| can_kill(op)}
	opponents.sort{ |a,b| a.stats[:health] <=> b.stats[:health] }.first
  end
  
  def can_kill(opp_player)
	points = self.stats[:strength] - (opp_player.stats[:defense]/2)
	opp_player.stats[:health] <= points
  end
  
  def list_opponents
	Game.world[:players].select{|p|p != self}
  end
  
  def move
	if self.stats[:health] >= 30
		if !find_killable_opponent.empty?
			[:attack, find_killable_opponent]
		else
			[:attack, find_max_damage]
		end
    else
      [:rest]
    end
  end

  def to_s
    "Jayaram"
  end
end