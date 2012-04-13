module DavidK
  def horde
    true
  end
  
  def to_s
    "david karapetyan"
  end

  def move
    opponent, full_speed = killable_opponent
    if (stats[:health] >= 95 || full_speed) && !opponent.nil?
  	  [:attack, opponent]
    else
      [:rest]
    end
  end

  private

  def killable_opponent
  	all_opponents = Game.world[:players].select {|p| p.to_s != "david karapetyan"}
    if all_opponents.length == 1
      return all_opponents[0], :yes
    end
    n = 1
    possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n)}
    while possible_opponents.empty?
      n += 1
      possible_opponents = all_opponents.select {|o| can_kill_in_n_hits?(o, n)}
    end
    gang_score = Hash.new(0)
    attackees = all_opponents.map do |p|
      if p.respond_to?(:move) then
        player_move = p.move
        if player_move.length == 2 then
          player_move
        else
          nil
        end
      else
        nil
      end
    end.select {|m| m}.map {|m| m[1]}
    attackees.each {|k| gang_score[k] += 1}
    if stats[:health] < 100 && gang_score[self] > 0 then
      return nil, nil
    end
    # favor attacking players over monsters
    sorted_opponents = possible_opponents.sort {|a,b| gang_score[a] <=> gang_score[b]} 
    return sorted_opponents.select {|p| p.respond_to?(:move)}[0] || sorted_opponents[0], nil
  end

  def can_kill_in_n_hits?(player, n)
    enemy_stats = player.stats
    points = stats[:strength] - (enemy_stats[:defense] / 2)
    enemy_stats[:health] <= n * points
  end
end
