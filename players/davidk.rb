module DavidK
  # `move` recursion call mitigation
  def self.extended(base)
    base.instance_variable_set :@move_call_depth, 0
    base.instance_variable_set :@move_callee, nil
  end

  def to_s
    "david k"
  end

  def change_name(opponents)
    @name_changed = true
    singleton_class = class << self; self; end;
    player_names = opponents.map {|x| x.to_s}.join(" ")
    singleton_class.instance_eval do
      define_method(:to_s) do
        return player_names
      end
    end
  end
  
  def move
    all_opponents = Game.world[:players].select {|p| p != self}
    # change_name(all_opponents) unless @name_changed
    action = [:rest] # rest is the default
    if (@move_call_depth += 1) > 1
      @move_call_depth -= 1
      return [:attack, self]
    end
    # if less than 3 opponents then go all out
    opponent = pick_opponent(all_opponents)
    if all_opponents.length < 3
      @move_call_depth -= 1
      return [:attack, opponent]
    end
    if stats[:health] <= 80 && rand < 0.2
      @move_call_depth -= 1
      return action
    end
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
    # gang up on them with the others. we need to be careful how we choose to gang up
    # if we do it too well then we get to first position and everybody retaliates towards us.
    # if we do it too slow then we won't be first so we need to strike a balance in the beginning
    # and get more and more aggressive as the game progresses to completion
    my_strength = stats[:strength]
    death_sentences = all_opponents.map do |o| 
      eff_defense = o.stats[:defense] / 2.0 * ((o_attackers = predator_prey[o]).length + 1 + \
        (o.respond_to?(:move) && o.move[0] == :rest ? 1 : 0))
      attack_points = my_strength - eff_defense + \
        o_attackers.reduce(0) {|acc, att_strength| acc + att_strength[1]}
      o.stats[:health] <= attack_points ? [o, true, o_attackers.length] : [o, false]
    end.select {|x| x[1]}.sort {|a,b| a[2] <=> b[2]}
    if (len = death_sentences.length) > 0
      if all_opponents.length > 6 # too many people so go with the flow
        death_sentences[-1][0]
      else # safe to be aggressive
        death_sentences[0][0]
      end
    else # nobody has a death sentence so try to find somebody above or below us in exp and try to kill them
      exp_cache = Hash.new
      my_exp = stats[:experience]
      competitors_below = all_opponents.select {|x| (exp_cache[x] ||= x.stats[:experience]) <= my_exp}
      competitors_above = all_opponents.select {|x| exp_cache[x] > my_exp}
      competitors_below.sort! {|a,b| exp_cache[b] <=> exp_cache[a]}
      competitors_above.sort! {|a,b| exp_cache[a] <=> exp_cache[b]}
      competitors_above[0] || competitors_below[0]
    end
  end
end
