module DavidK2
  # `move` recursion call mitigation
  def self.extended(base)
    base.instance_variable_set :@move_call_depth, 0
    base.instance_variable_set :@move_callee, nil
  end

  def to_s
    "david k clone"
  end

  def move
    all_opponents = Game.world[:players].select {|p| p != self}
    action = [:rest] # rest is the default
    if (@move_call_depth += 1) > 1
      @move_call_depth -= 1
      return [:attack, self]
    end
    if stats[:health] <= 80 && rand < 0.2
      @move_call_depth -= 1
      return action
    end
    opponent = pick_opponent(all_opponents)
    if opponent && stats[:health] >= 95
  	  action = [:attack, opponent]
    end
    @move_call_depth -= 1
    return action
  end

  private
  
  def pick_opponent(all_opponents)
    # try to figure out who's attacking who
    predator_prey = Hash.new([])
    all_opponents.each do |enemy|
      if enemy.respond_to?(:move) && (attackee = enemy.move[1])
        predator_prey[attackee] += [[enemy, enemy.stats[:strength]]]
      end
    end
    # if I have attackers then retaliate towards the weakest one
    if (attackers = predator_prey[self]).any?
      return attackers.sort {|a,b| a[0].stats[:health] <=> b[0].stats[:health]}[0][0]
    end
    # I have no attackers. see if anyone has a death sentence, i.e. they will die if I
    # gang up on them with the others
    my_strength = stats[:strength]
    all_opponents.map do |o| 
      eff_defense = o.stats[:defense] / 2.0 * ((o_attackers = predator_prey[o]).length + 1 + \
        (o.respond_to?(:move) && o.move[0] == :rest ? 1 : 0))
      attack_points = my_strength + \
        o_attackers.reduce(0) {|acc, att_strength| acc + att_strength[1]} - eff_defense
      if o.stats[:health] <= attack_points
        return o
      end
    end
    # nobody had a death sentence so return nil which just means we'll rest
    return nil
  end
end
