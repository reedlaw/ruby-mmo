module ATabbyCat
  def to_s
    'A Tabby Cat'
  end
  
  def move
    @prey = select_prey
    if killable? @prey || health_looks_okay?
      [:attack, @prey]
    else
      [:rest]
    end
  end
  
  private
  def select_prey
    strongest_killable_human || rat || healthiest_human
  end

  def health_looks_okay?
    @prey.stats[:health] <= stats[:health]
  end

  def killable? prey
    stats[:strength] - prey.stats[:defense] / 2 >= prey.stats[:health]
  end
  
  def players
    Game.world[:players]
  end

  def humans
    players.select { |p| p != self }
  end

  def strongest_killable_human
    humans.select { |p| killable? p }.max { |p| p.stats[:experience] }
  end

  def healthiest_human
    humans.max { |p| p.stats[:health] }
  end

  def rats
    players.select { |p| p.to_s == 'rat' }
  end

  def rat
    rats.sample
  end
end