module ATabbyCat
  def to_s
    'A Tabby Cat'
  end
  
  def move
    @opponent = select_opponent
    if cat_has_advantage?
      [:attack, @opponent]
    else
      [:rest]
    end
  end
  
  private
  def select_opponent
    mercy_kill? || rat? || weakest_player
  end
  
  def mercy_kill?
    players.select { |player| killable? player }.first
  end

  def killable? player
    stats[:strength] - (player.stats[:defense] / 2) > player.stats[:health]
  end
  
  def rat?
    Game.world[:players].select { |p| p.to_s == 'rat' }.first
  end
  
  def players
    Game.world[:players].select { |p| p != self }
  end
  
  def weakest_player
    players.min { |a, b| a.stats[:health] <=> b.stats[:health] }
  end
  
  def cat_has_advantage?
    stats[:health] > @opponent.stats[:health]
  end
end