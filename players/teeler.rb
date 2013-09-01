module Teeler
 
  def self.extended(base)
    base.instance_variable_set :@round, 0
  end

  def to_s
    "Teeler"
  end
 
  def move
    @round += 1
    cataclysm
  end
 
  def cataclysm
    if should_battle?
      fight
    else
      monk
    end
  end
 
  def should_battle?
    if health >= 100 && @round < 10
      true
    elsif @round >= 80
      true
    elsif xp > xp(middle_of_pack)
      false
    else
      true
    end
  end

  def fight
    if @round < 20
      p_v_e
    else 
      p_v_p 
    end
  end
 
  def next_opponent
    if @round > 80
      leader
    else
      weakest
    end
  end

  def monk
    [:rest] 
  end
 
  def p_v_e 
    [:attack, rat] 
  end
 
  def p_v_p
    [:attack, next_opponent] 
  end
 
  def opponents
    Game.world[:players].select { |p| p != self && p.to_s != 'rat' }
  end

  def monsters
    Game.world[:players].select { |p| p.to_s == 'rat' }
  end

  def rat
    rats = monsters.select { |p| p.alive }
    if rats.empty?
      false
    else
      rats.shuffle[rats.count/2] #random
    end
  end

  def weakest
    opponents.min_by { |p| health(p) }
  end

  def leader
    opponents.max_by { |p| xp(p) }
  end

  def middle_of_pack
    opponents.sort_by! { |p| xp(p) }
    opponents[opponents.count/2]
  end
 
  def xp(p = self)
    p.stats[:experience]
  end

  def level(p = self)
    p.stats[:level]
  end
 
  def health(p = self)
    p.stats[:health]
  end
end