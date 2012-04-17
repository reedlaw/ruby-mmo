module Jurek
  def move
    # flee from the battlefield to rest if injured
    if full_health?
      unless Game.world[:players].include?(self)
        Game.world[:players] << self
      end
    else
      Game.world[:players].reject! { |p| p == self }
    end

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
    rat || dying_player
  end

  def rat
    players.select{|p| p.to_s == 'rat' }.first
  end

  def most_experienced
    players.max { |a,b| experience(a) <=> experience(b) }
  end

  def dying_player
    players.find { |p| dying?(p) }
  end
  def weakest
    players.min { |a,b| health(a) <=> health(b) }
  end

  def players
    Game.world[:players].select { |p| p != self }
  end

  def in_danger?(p = self)
    health(p) <= 70
  end
  def dying?(p = self)
    health(p) <= 30
  end
  def winning?(p = self)
    p == most_experienced
  end
  def full_health?(p = self)
    health(p) == 100
  end

  def experience(p = self)
    p.stats[:experience]
  end
  def health(p = self)
    p.stats[:health]
  end

  def to_s
    "Jurek"
  end
end

