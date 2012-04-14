module DavidK
  # `move` recursion call mitigation
  def self.extended(base)
    base.instance_variable_set :@move_call_depth, 0
    base.instance_variable_set :@move_callee, nil
  end
  
  # join the horde
  def horde
    true
  end
  
  def to_s
    "david karapetyan"
  end

  def move
    @move_call_depth += 1 
    if @move_call_depth > 1 # this means somebody is trying to figure out what we are doing so we lie
      @move_call_depth -= 1
      return [:rest]
    end
    action = [:rest]
    opponent = killable_opponent
    if stats[:health] >= 0 && !opponent.nil?
  	  action = [:attack, opponent]
    end
    @move_call_depth -= 1
    return action
  end

  private

  def n_hit_killables(opponents)
    n = 1
    while (possible_opponents = opponents.select {|o| can_kill_in_n_hits?(o, n)}).empty?
      n += 1
    end
    possible_opponents
  end
  
  def gang_score_and_aggro(opponents)
    g_score = Hash.new(0)
    predator_prey_relation = Hash.new([])
    opponents.each do |p|
      if p.respond_to?(:move) # monsters don't respond to move
        @move_callee, player_move = p, p.move
        if player_move.length == 2 # see if the player is attacking somebody
          attackee = player_move[1] # who is the player attacking
          # increment gang score and track the attacker
          g_score[attackee] += 1
          predator_prey_relation[attackee] += [p]
        end
      end
    end
    return g_score, predator_prey_relation
  end
  
  # find somebody we can potentially attack or return nil in case we should be resting
  def killable_opponent
    all_opponents = Game.world[:players].select {|p| p.to_s != "david karapetyan"}
    if all_opponents.select {|p| !p.respond_to?(:move)}.length > 0
      return nil
    end
    # find people we could potentially kill
    possible_opponents = n_hit_killables(all_opponents)
    # compute some metrics and relations to be used in our strategy
    gang_score, aggro = gang_score_and_aggro(all_opponents)
    # order possible opponents according to gang score. lower score is better because
    # we get more experience in that case
    sorted_opponents = possible_opponents.sort {|a,b| gang_score[b] <=> gang_score[a]}
    # see who my attackers are and sort them according to gang score as well
    my_attackers = aggro[self].sort {|a,b| gang_score[b] <=> gang_score[a]}
    return my_attackers[0] || sorted_opponents[1] || sorted_opponents[0]
  end

  # figure out whether at our current strength level we can kill an opponent in n hits
  # according to how the game engine calculates health loss
  def can_kill_in_n_hits?(player, n)
    enemy_stats = player.stats
    points = stats[:strength] - (enemy_stats[:defense] / 2)
    enemy_stats[:health] <= n * points
  end
end
