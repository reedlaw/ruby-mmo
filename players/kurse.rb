module KurSe
  MAX_HEALTH = 100

  def to_s
    "KurSe"
  end
  
  def move
    (stats[:health] != MAX_HEALTH) ? [:rest] : [:attack, get_target]
  end

  protected
  def get_target
    opponents = Game.world[:players].select{ |p|p != self }
    opponents.sort {|x,y| x.stats[:health] <=> y.stats[:health]}[1]
  end
end