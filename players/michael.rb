module ZMichael
  def move
    player_count = Game.world[:players].count
    opponent = least_health_opponent
    leader = current_leader

    case
      when ((opponent.stats[:health] + (opponent.stats[:defense]/2)) <  self.stats[:strength]) && self.stats[:experience] <= leader.stats[:experience]+100
        [:attack,opponent]
      when self.stats[:health] < 100
        [:rest]
      when player_count == 2 && self.stats[:health] > opponent.stats[:health]
        [:attack, opponent]
      else
        [:rest]
    end
  end

  def to_s
    "Michael"
  end

  def least_health_opponent
    for opponent in Game.world[:players].select{|p|p != self}

      if @least_health_opponent.nil?
        @least_health_opponent = opponent
      end

      if opponent.stats[:health] < @least_health_opponent.stats[:health] && @least_health_opponent.alive?
      @least_health_opponent = opponent
      else @least_health_opponent = opponent
      end

    end
    @least_health_opponent
  end


  def current_leader
    for opponent in Game.world[:players].select{|p|p != self}
      if @current_leader.nil?
        @current_leader = opponent
      end

      if opponent.stats[:experience] > @current_leader.stats[:experience]
        @current_leader = opponent
        puts "new winner fire away"
      end
    end

    @current_leader
  end



end


