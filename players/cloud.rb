module Cloud
  HEALTH_INDEX = [100,110,125,145,170,195,225,260]
  
  def to_s
    "Z Cloud Strife"
  end
  
  def move
    if full_health? && !winning
        kill_or_leader
    else
      [:rest]
    end
  end
  
  def opponents
    Game.world[:players].select{|p| p!=self && health(p) > 0}
  end
  
  def lowest_hp
    opponents.min { |a,b| health(a) <=> health(b) }
  end
  
  def biggest_threat
    opponents.max { |a,b| experience(a) <=> experience(b) }
  end
  
  def winning
    experience(biggest_threat) < experience(self)
  end
  
  def rat
    rats = Game.world[:players].select{|p| p!=self && p.alive && p.to_s == "rat"}
    if rats.count < 4 || self.stats[:level] == 1
      false
    else
      rats[2]
    end
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
    health(self) == max_health(self)
  end
  
  def one_on_one
    opponents.count == 1
  end
  
  def kill_or_leader
    if limit_break(self, lowest_hp)
      [:attack, lowest_hp]
    elsif rat
      [:attack, rat]
    else
      [:attack, biggest_threat]
    end
  end
  
  def max_health(p)
   HEALTH_INDEX[p.stats[:level]]
  end
  
  def health(p)
    p.stats[:health]
  end
  
  def strength(p)
    p.stats[:strength]
  end
  
  def experience(p)
    p.stats[:experience]
  end
  
  def defense(p)
    p.stats[:defense]
  end
end