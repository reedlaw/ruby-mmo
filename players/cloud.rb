module Cloud
  def to_s
    "Z Cloud Strife"
  end
  
  def move
    too_many_opponents
    if health(self) <= 90
      [:rest]
    else
      kill_or_leader
    end
  end
  
  private
  
  def opponents
    Game.world[:players].select{|p| p!=self && health(p) > 0 && p.to_s != "rat"}
  end
  
  def lowest_hp
    opponents.min { |a,b| health(a) <=> health(b) }
  end
  
  def biggest_threat
    opponents.max { |a,b| a.stats[:experience] <=> b.stats[:experience] }
  end
  
  def limit_break
    damage = self.stats[:strength] - (lowest_hp.stats[:defense] / 2)
    health(lowest_hp) <= damage
  end
  
  def full_health?
    self.stats[:health] == 100
  end
  
  def one_on_one
    opponents.count == 1
  end
  
  def kill_or_leader
    if limit_break
      [:attack, lowest_hp]
    else
      [:attack, biggest_threat]
    end
  end
  
  def hits_to_kill
    health(lowest_hp)/self.stats[:strength]
  end
  
  def too_many_opponents
    if opponents.count < 5
      unless Game.world[:players].include?(self)
        Game.world[:players] << self
      end
    else
      Game.world[:players].reject! { |p| p == self }
    end
  end
  
  def health(p)
    p.stats[:health]
  end
end