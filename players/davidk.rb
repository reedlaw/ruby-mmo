module DavidK
  # `move` recursion call mitigation
  def self.extended(base)
    base.instance_variable_set :@move_call_depth, 0
    base.instance_variable_set :@move_callee, nil
    base.instance_variable_set :@previous_aggro_attacker, nil
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
    opponent = pick_opponent
    if stats[:health] >= 80 && !opponent.nil?
  	  action = [:attack, opponent]
    end
    @move_call_depth -= 1
    return action
  end

  private
  
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
  def pick_opponent
    all_opponents = Game.world[:players].select {|p| p.to_s != "david karapetyan"}
    # compute some metrics and relations to be used in our strategy
    gang_score, aggro = gang_score_and_aggro(all_opponents)
    sorted_opponents = all_opponents.sort do |a,b| 
      [-b.stats[:health], gang_score[b]] <=> [-a.stats[:health], gang_score[a]]
    end
    # see who my attackers are and sort them according to gang score as well
    my_attackers = aggro[self].sort {|a,b| [gang_score[b], -b.stats[:health]] <=> [gang_score[a], -a.stats[:health]]}
    puts "------------ attackers -----------"
    puts my_attackers
    puts "----------------------------------"
    my_attackers[0] || sorted_opponents[0..1].last
  end
end
