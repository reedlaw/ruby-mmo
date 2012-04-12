module SouthPoleSteve
  def to_s
    "South Pole Steve"
  end

  def move
    return [:attack, killable_opponents.select{ |p| p.stats[:health] < 30 }.pop] unless killable_opponents.empty?  

    return [:attack, opponents.first] if opponents.size == 1 || stats[:health] >= 100

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
