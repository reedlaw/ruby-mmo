module RogueLeader
  def to_s
    "Rogue Leader"
  end
  def move
    return [:attack, killable_opponents.select{ |p| health < 30 }.pop] unless killable_opponents.empty?  

    return [:attack, opponents.first] if opponents.size == 1 || health >= 100

    [:rest]
  end

  private
  
  def health(player = self)
    player.stats[:health] 
  end 
  
  def opponents
    Game.world[:players].select{ |p| p != self }
  end

  def killable_opponents
    opponents.select { |o| can_kill?(o) }
  end

  def can_kill?(player)
    points = stats[:strength] - (player.stats[:defense] / 2)
    player.stats[:health] <= points
  end

  def faction
    :rogue_squadron
  end

  def attack_pattern_delta(player)
  end

  def radar_sweep
  end
end
