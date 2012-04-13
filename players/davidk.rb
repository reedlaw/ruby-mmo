module DavidK
  def to_s
    "david karapetyan"
  end

  def move
    opponent, full_speed = killable_opponent
    if (stats[:health] >= 50 || full_speed) && !opponent.nil?
  	  [:attack, opponent]
    else
      [:rest]
    end
  end

  private

  def killable_opponent
  	all_opponents = Game.world[:players].select{|p| p != self}
    if all_opponents.length == 1
      return all_opponents[0], :yes
    end
  	n = 1
    possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n)}.sort {|a,b| b.stats[:health] <=> a.stats[:health]}
    #while possible_opponents.empty?
    #	n += 2
    #	possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n)}.sort {|a,b| b.stats[:health] <=> a.stats[:health]}
    #end
    return possible_opponents.first, nil
  end
  
  def can_kill_in_n_hits?(player, n)
    enemy_stats = player.stats
    points = stats[:strength] - (enemy_stats[:defense] / 2)
    enemy_stats[:health] <= n * points
  end
end
