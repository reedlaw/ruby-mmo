module Cloud
  def to_s
    "Z Cloud Strife"
  end
  
  def move
    too_many_opponents
    if full_health?
      kill_or_leader
    else
      [:rest]
    end
  end
  
  def opponents
    Game.world[:players].select{|p| p!=self && health(p) > 0 && p.to_s != "rat"}
  end
  
  def lowest_hp
    opponents.min { |a,b| health(a) <=> health(b) }
  end
  
  def biggest_threat
    opponents.max { |a,b| a.stats[:experience] <=> b.stats[:experience] }
  end
  
  def calculate_damage(strength , defense)
     if defense != 0
       strength - (defense / 2)
     else
       strength
    end
  end
  
  def limit_break(p, p2)
    health(p) <= calculate_damage(strength(p), defense(p))
  end
  
  def full_health?
    health(self) == 100
  end
  
  def one_on_one
    opponents.count == 1
  end
  
  def kill_or_leader
    if limit_break(self, lowest_hp)
      [:attack, lowest_hp]
    else
      [:attack, biggest_threat]
    end
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
  
  def strength(p)
    p.stats[:strength]
  end
  
  def defense(p)
    p.stats[:defense]
  end
end