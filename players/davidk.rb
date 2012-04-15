module DavidK
  # `move` recursion call mitigation
  def self.extended(base)
    base.instance_variable_set :@move_call_depth, 0
    base.instance_variable_set :@move_callee, nil
  end

  def to_s
    "david k"
  end

  def move
    action = [:rest] # rest is the default
    if (@move_call_depth += 1) > 1 # this means somebody is trying to figure out what we are doing so we lie
      @move_call_depth -= 1
      return action
    end
    if stats[:health] <= 90 && rand < 0.2
      @move_call_depth -= 1
      return action
    end
    opponent = pick_opponent
    if opponent
  	  action = [:attack, opponent]
    end
    @move_call_depth -= 1
    action
  end

  private
  
  def pick_opponent
    all_opponents = Game.world[:players].select {|p| p != self}
    all_opponents.find {|p| p.to_s == "Chuck Norris"} || all_opponents.sort {|a,b| b.stats[:experience] <=> a.stats[:experience]}[0]
  end
end
