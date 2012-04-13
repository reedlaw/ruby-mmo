module Noob
  def move
    if winning? && (health < 100)
      [:rest]
    else
      if in_danger? || !enemy
        [:rest]
      else
        [:attack, enemy]
      end
    end
  end

  def enemy
    rat || dying_player || most_experienced
  end

  def rat
    #find a rat that's not beeing attacked
    rats = opponents.select { |p| p.to_s == 'rat' }
    if rats.size > 1 
      humans = opponents.reject { |p| p.to_s == 'rat' }
      rats.reject! do |r|
        humans.find { |p| p.move[1].to_s == r.to_s } 
      end
      rats.sample
    else
      nil
    end
  end

  def most_experienced
    opponents.max_by { |a| experience(a) }
  end

  def dying_player
    opponents.find { |p| dying?(p) && p.to_s != 'rat' }
  end
  def weakest
    opponents.min_by { |a| health(a) }
  end

  def players
    Game.world[:players]
  end

  def opponents
    players.select { |p| p != self }
  end

  def in_danger?(p = self)
    health(p) <= 70
  end
  def dying?(p = self)
    health(p) <= 30
  end
  def winning?(p = self)
    p == players.max_by { |p| experience(p) }
  end
  def full_health?(p = self)
    health(p) == 100
  end
  def place(p = self)
    players.sort_by { |p| -experience(p) }.index(p) + 1
  end

  def experience(p = self)
    p.stats[:experience]
  end
  def health(p = self)
    p.stats[:health]
  end

  def to_s
    "*noob*"
  end
end
