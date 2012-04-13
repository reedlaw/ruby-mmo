module StealthyGuy
  def ==(other)
    # we only want to be == to someone else if another player is
    # asking; if the game engine is asking, we emphatically don't want
    # to be == to anybody else. Otherwise, when the game engine is
    # finding the player to deal damage to, it finds us, and we die in
    # a big damn hurry.
    if other.is_a?(PlayerProxy) and caller[0] =~ /\/players\//
      true
    else
      super
    end
  end

  def move
    opponent = find_weakest_opponent
    opponent ? [:attack, opponent] : [:rest]
  end

  def to_s
    "Stealthy Guy"
  end

  def find_weakest_opponent
    rat = Game.world[:players].detect do |player|
      player.to_s == "rat"
    end
    return rat if rat
    
    Game.world[:players].select do |player|
      self.object_id != player.object_id
    end.min do |p1, p2|
      p1.stats[:health] <=> p2.stats[:health]
    end
  end
end
