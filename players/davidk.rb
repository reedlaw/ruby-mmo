module DavidK
  def to_s
    "david karapetyan"
  end

  def move
    opponent = killable_opponent
  	if stats[:health] >= 50 && !opponent.nil?
  	  [:attack, opponent]
    else
      [:rest]
    end
  end

  private

  def killable_opponent
    all_opponents = Game.world[:players].select{|p| p != self}
    n = 1
    possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n)}.sort {|a,b| b.stats[:health] <=> a.stats[:health]}
    #while possible_opponents.empty?
    #	n += 2
    #	possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n)}.sort {|a,b| b.stats[:health] <=> a.stats[:health]}
    #end
    possible_opponents.first
  end
  
  def can_kill_in_n_hits?(player, n)
    enemy_stats = player.stats
    points = stats[:strength] - (enemy_stats[:defense] / 2)
    enemy_stats[:health] <= n * points
  end
end
