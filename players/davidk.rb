module DavidK
  def to_s
    "david karapetyan"
  end

  def move
  	if stats[:health] >= 90
    	[:attack, killable_opponent]
    else
    	[:rest]
    end
  end

  private

  def killable_opponent
  	all_opponents = Game.world[:players].select{ |p| p != self }
  	n = 1
    possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n) }
    while possible_opponents.empty?
    	n += 2
    	possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n) }
    end
    possible_opponents.first
  end
  
  def can_kill_in_n_hits?(player, n)
  	enemy_stats = player.stats
  	points = stats[:strength] - (enemy_stats[:defense] / 2)
  	enemy_stats[:health] <= n * points
  end
  
end
