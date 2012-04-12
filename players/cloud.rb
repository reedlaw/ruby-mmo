module Cloud
  def to_s
    "Z Cloud Strife"
  end
  
  def move
    hide_if_low_hp
    if full_health? || one_on_one
      if limit_break
        [:attack, lowest_hp]
      else
        [:attack, biggest_threat]
      end
    else
      if self.stats[:health] < 60
        [:rest]
      else
        if limit_break
          [:attack, lowest_hp]
        else
          [:rest]
        end
      end
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
  
  def hits_to_kill
    health(lowest_hp)/self.stats[:strength]
  end
  
  def hide_if_low_hp
    if health(self) >= 60 
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