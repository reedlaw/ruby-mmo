module DavidK
  def horde
    true
  end
  
  def to_s
    "david karapetyan"
  end

  def move
    opponent, full_speed = killable_opponent
    if (stats[:health] >= 90 || full_speed) && !opponent.nil?
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
    possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n)}
    # give each attacked player a gang score, higher scores are worse
    gang_score = Hash.new(0)
    all_opponents.map {|p| p.move}.select {|m| m.length > 1}.map {|m| m[1]}.each {|k| gang_score[k] += 1}
    # sort possible opponents by gang score and pick the one with the lowest score
    return possible_opponents.min {|a,b| gang_score[a] <=> gang_score[b]}, nil
  end

  # @return [BooleanLiteral]
  # @param player [Object]
  # @param n [integer]
  def can_kill_in_n_hits?(player, n)
    enemy_stats = player.stats
    points = stats[:strength] - (enemy_stats[:defense] / 2)
    enemy_stats[:health] <= n * points
  end
end
