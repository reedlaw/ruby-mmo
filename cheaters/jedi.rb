module Jedi
  def move
    if at_risk?
      [:rest]
    else
      [:attack, easy_prey || weakest_link]
    end
  end
  
  # These are not the droids you are looking for.
  def ==(other)
    false
  end

  def to_s
    "Jedi"
  end

  def opponents
    Game.world[:players].select { |p| p != self && p.alive }
  end

  def at_risk?
    stats[:health] != 100 && Game.world[:players].sort_by { |p| p.stats[:health] }.index(self) < Game.world[:players].count/2
  end

  def weak_to_strong
    opponents.sort_by { |p| p.stats[:health] }
  end

  def weakest_link
    weak_to_strong.first
  end

  def rat
    opponents.select { |p| p.to_s == "rat" }.drop(1).sample
  end

  def easy_prey
    rat || weak_to_strong.take_while { |p| p.stats[:health] < stats[:strength] - p.stats[:defense]/2 }.first
  end
end
