module DavidK
  # move recursion call mitigation
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

  # if there are no checks then if another player tries to check our moves this will lead to
  # an infinite loop because killable_opponent will call move on another player which will call
  # move on us and so on and so forth
  def move
    @move_call_depth += 1 
    if @move_call_depth > 1 # this means somebody is trying to figure out what we are doing so we lie
      @move_call_depth -= 1
      return [:rest]
    end
    action = [:rest]
    opponent, full_speed = killable_opponent
    if (stats[:health] >= 50 || full_speed) && !opponent.nil?
  	  action = [:attack, opponent]
    end
    @move_call_depth -= 1
    return action
  end

  private

  # find somebody we can kill by relaxing the number of hits
  def n_hit_killables(opponents)
    n = 1
    while (possible_opponents = opponents.select {|o| can_kill_in_n_hits?(o, n)}).empty?
      n += 1
    end
    possible_opponents
  end
  
  # go through all players other than self and build up some hash maps that can be used
  # for picking an opponent to attack
  def gang_score_and_aggro(opponents)
    g_score = Hash.new(0)
    predator_prey_relation = Hash.new([])
    opponents.each do |p|
      if p.respond_to?(:move) # monsters don't respond to move
        @move_callee, player_move = p, p.move
        if player_move.length == 2 then # see if the player is attacking somebody
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
    # special logic when only one player is left
    if all_opponents.length == 1
      return all_opponents[0], :yes
    end
    # find people we could potentially kill
    possible_opponents = n_hit_killables(all_opponents)
    # compute some metrics and relations to be used in our strategy
    gang_score, aggro = gang_score_and_aggro(all_opponents)
    # see if only one perseon is attacking us and our health is less than 80
    # and rest if that's true. the reason is that we can mitigate health loss
    # in this case at the expense of more experience points. we last longer but
    # potentially drop down the ladder
    if stats[:health] < 80 && gang_score[self] < 2 then
      return nil, nil
    end
    # order possible opponents according to gang score. lower score is better because
    # we get more experience in that case
    sorted_opponents = possible_opponents.sort {|a,b| gang_score[a] <=> gang_score[b]}
    # see if there are any monsters we can attack because they are easy to kill. if that's
    # not the case then attack the opponent with the lowest gang score because a kill in that
    # case is more beneficial in terms of experience.
    return sorted_opponents.select {|p| !p.respond_to?(:move)}[0] || sorted_opponents[0], nil
  end

  # figure out whether at our current strength level we can kill an opponent in n hits
  # according to how the game engine calculates health loss
  def can_kill_in_n_hits?(player, n)
    enemy_stats = player.stats
    points = stats[:strength] - (enemy_stats[:defense] / 2)
    enemy_stats[:health] <= n * points
  end
end
