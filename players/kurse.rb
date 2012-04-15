module KurSe
  DANGER_HP_ZONE = [0,1,2]
  DANGER_XP_ZONE = [0,1]
  
  def to_s
    "KurSe"
  end
  
  def move
    calm_down ? [:rest] : [:attack, get_target]
  end

  protected
  def get_target
    opponents = Game.world[:players].select{|x| x != self}
    opponents = opponents.sort {|x,y| x.stats[:health] <=> y.stats[:health]}
    opponents[1]
  end

  def calm_down
    DANGER_HP_ZONE.include?(rank_hp) || DANGER_XP_ZONE.include?(rank_xp)
  end

  def rank_xp
    Game.world[:players].sort_by{|x| x.stats[:experience]}.reverse.index(self)
  end

  def rank_hp
    Game.world[:players].select{|x| x.stats[:health] != 0}.sort_by{|x| x.stats[:health]}.index(self)
  end
end