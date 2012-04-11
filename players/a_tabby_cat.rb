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
    rat? || weakest_player
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
    self.stats[:health] > @opponent.stats[:health]
  end
end