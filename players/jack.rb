module Jack
  def horde
    true
  end
  def move
    enemy = Game.world[:players].select { |p| !p.horde && p.alive }.min { |a,b| a.stats[:health] <=> b.stats[:health] }
    if enemy && self.stats[:health] > self.stats[:strength]
      [:attack,enemy]
    else
      [:rest]
    end
  end
  def to_s
    "Jack"
  end
end
