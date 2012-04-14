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
    if stats[:health] >= 90 && !opponent.nil?
  	  action = [:attack, opponent]
    end
    @move_call_depth -= 1
    action
  end

  private
  
  def gang_score_and_aggro(opponents)
    g_score = Hash.new(0)
    predator_prey_relation = Hash.new([])
    opponents.each do |p|
      if p.respond_to?(:move) # monsters don't respond to move
        @move_callee, player_move = p, p.move
        if (attackee = player_move[1]) # see if the player is attacking somebody
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
    # swartzian transform
    health_cache = Hash.new
    sorted_opponents = all_opponents.sort do |a,b| 
      [gang_score[b], health_cache[b] ||= b.stats[:health]] <=> [gang_score[a], health_cache[a] ||= a.stats[:health]]
    end
    choices = sorted_opponents[0..2]
    choices[rand(choices.length)]
  end
end
