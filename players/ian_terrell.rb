module IanTerrell
  HEALTH_BUFFER = 1.5
  
  def move
    if i_can_be_killed?
      if those_who_can_kill_me.size == 1 && i_can_kill?(those_who_can_kill_me.first)
        [:attack, those_who_can_kill_me.first]
      else
        [:rest]
      end
    else
      if those_killable.empty?
        if stats[:health] > HEALTH_BUFFER * opponents_max_health
          [:attack, random_low_health_opponent]
        else
          [:rest]
        end
      else
        [:attack, those_killable.first]
      end
    end
  end
  
  def to_s
    "Ian Terrell"
  end
  
protected  
  def i_can_be_killed?
    opponents.any?{ |player| can_kill?(player, self) }
  end
  
  def i_can_kill?(defender)
    can_kill?(self, defender)
  end
  
  def expected_damage(aggressor, defender)
    aggressor.stats[:strength] - defender.stats[:defense]/2
  end
  
  def can_kill?(aggressor, defender)
    expected_damage(aggressor, defender) > defender.stats[:health]
  end
  
  def opponents
    Game.world[:players].select{ |player| player != self}
  end
  
  def opponents_max_health
    opponents.map{ |player| player.stats[:health] }.max
  end
  
  def opponents_min_health
    opponents.map{ |player| player.stats[:health] }.min
  end
  
  def those_killable
    opponents.select{ |player| can_kill?(self, player) }
  end
  
  def those_who_can_kill_me
    opponents.select{ |player| can_kill?(player, self) }
  end
  
  def those_with_low_health
    lowest_health = opponents_min_health
    opponents.select{ |player| player.stats[:health] == lowest_health }
  end
  
  def random_low_health_opponent
    low_health_opponents = those_with_low_health
    low_health_opponents[rand(low_health_opponents.size)]
  end
end