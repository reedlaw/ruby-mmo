module RogueLeader
  def to_s
    "Rogue Leader"
  end

  def move
    action = if killable_opponents.any?
                [:attack, killable_opponents.select{ |p| health < 30 }.first]
             elsif opponents.size == 1 || health >= 100
                [:attack, opponents.first]
             else
               [:rest]
             end
    action 
  end

  private
  
  def health(player = self)
    player.stats[:health] 
  end 
  
  def opponents
    Game.world[:players].select { |p| p != self }
  end

  def players
    Game.world[:players].select { |p| p.to_s != "rat" }
  end

  def killable_opponents
    opponents.select { |o| can_kill?(o) }
  end

  def can_kill?(player)
    points = stats[:strength] - (player.stats[:defense] / 2)
    player.stats[:health] <= points && player.alive
  end

  def faction
    :rogue_squadron
  end

  # IFF Horde
  def horde 
    true
  end
  
end
