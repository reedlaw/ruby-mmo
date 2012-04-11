module EricTheKillSteal
  def to_s
    "Eric the Kill Steal"
  end

  def move
    return [:attack, killable_opponents.first] unless killable_opponents.empty?  

    [:rest]
  end

  private
  
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
end
