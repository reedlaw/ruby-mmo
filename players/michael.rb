module Michael
  def move
    opponent = least_health_opponent
    case
      when kill_zone?(opponent)
        [:attack, opponent]

      when opponents == 1 && opponent < my_health

      else
        [:rest]
    end
  end

  def to_s
    "Michael"
  end

  def players
    Game.world[:players].select
  end

  def opponents
    Game.world[:players].select{ |player| player != self}
  end


  def least_health_opponent
    opponents.inject {|min, player| player.stats[:health] > min.stats[:health] ? min : player }
  end

  def kill_zone?(player)
     (player.stats[:health] + player.stats[:defense]/2) <= self.stats[:strength]
  end

  def my_health
    self.stats[:health]
  end

end


