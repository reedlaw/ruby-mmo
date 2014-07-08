module Josh
  def to_s
    "Van Diagram"
  end

  def move
    if weakest? && can_drag_under?
      [:attack, second_weakest]
    elsif experience_leader? || health_concerns?
      #the others like to come after the strongest and the weakest
      #try to stay off that radar.
      [:rest]
    elsif weakest_is_a_rat?
      [:attack, quiet_rat]
    else
      [:attack, weakest]
    end
  end

  private

  def weakest
    players_by_health.first
  end

  def weakest?
    weakest == self
  end

  def players_by_health
    Game.world[:players].sort{|a, b| a.stats[:health] <=> b.stats[:health]}
  end

  def players_by_experience
    Game.world[:players].sort{|a, b| b.stats[:experience] <=> a.stats[:experience]}
  end

  def survivors
    Game.world[:players].count
  end

  def ten_pct
    survivors / 10 + 1
  end

  def weakest_is_a_rat?
    weakest.to_s == "rat"
  end

  def quiet_rat #everybody wants to attack the first one up
    players_by_health.select{|p| p.to_s == 'rat'}.sample
  end

  def experience_leader?
    players_by_experience.first(ten_pct).include?(self)
  end

  def health_concerns?
    self.stats[:health] < 100
  end

  def second_weakest
    players_by_health[1]
  end

  def gap(player)
    player.stats[:health] - self.stats[:health]
  end

  #if i'm weakest, can i attack someone else and potentially get them below me?
  def can_drag_under?
    return self.stats[:strength] - second_weakest.stats[:defense] / 2 > gap(second_weakest)
  end

end
