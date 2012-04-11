module Shannon
  def to_s
    'A Tabby Cat'
  end
  
  def move
    @opponent = select_opponent
    
    advantage? ? [:attack, @opponent] : [:rest]
  end
  
  private
  
  def select_opponent
    rat? || weakest_player
  end
  
  def rat?
    Game.world[:players].select { |p| p.to_s == 'rat' }.first
  end
  
  def weakest_player
    players = Game.world[:players].select { |p| p != self }
    players.min { |a, b| a.stats[:health] <=> b.stats[:health] }
  end
  
  def advantage?
    self.stats[:health] > @opponent.stats[:health]
  end
end