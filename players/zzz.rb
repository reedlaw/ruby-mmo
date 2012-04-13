class Array
  def except(obj)
    self.reject {|item| item == obj}
  end
end

module ZZZ
  HEALTH_THRESHOLD      = 90
  DYING_THRESHOLD       = 40
  TOO_HEALTHY_THRESHOLD = 80

  def all_opponents
    Game.world[:players].except(self).sort_by {|p| p.stats[:health]}
  end

  def dying_opponents
    all_opponents.find_all {|p| p.stats[:health] <= DYING_THRESHOLD}
  end

  def healthy_opponents
    all_opponents.find_all {|p| p.stats[:health] > TOO_HEALTHY_THRESHOLD}
  end

  def move
    if self.stats[:health] >= HEALTH_THRESHOLD
      if dying_opponents.count > 0
        [:attack, dying_opponents.first]
      elsif healthy_opponents.count > 0
        [:attack, healthy_opponents.first]
      elsif self.stats[:health] < 100
        [:rest]
      else
        [:attack, all_opponents.last]
      end
    else
      [:rest]
    end
  end

  def to_s
    "| Drowsy Leo |"
  end
end