module Strax
  def move
    # When in danger or when already winning, rest (except when there's an opportunity to finish an opponent to reduce probability of mass attack against self)
    if (danger? || (won? && !dying))
      [:rest]
    else
      [:attack, target]
    end
  end

  def to_s
    "strax"
  end

  private

  # No way our experience can be matched anymore.
  def won?
    experience(leader) + opponents.count * 100 < experience
  end

  # Determines an available target
  def target
    dying || leader
  end

  # Make sure opponents can't kill us with everyone against you 
  def danger?
    health < 100 && health - opponents.reduce(0) {|sum, p| sum + damage_projection(p, self)} > 0
  end

  # Returns the current contender to self
  def leader
    opponents.max_by {|p| experience(p) }
  end

  # Returns a target that can be killed with a single attack.
  def dying
    opponents.select {|p| can_kill?(p) }.sample
  end

  # Determines if an enemy can be killed with one hit
  def can_kill?(opponent)
    health(opponent) - damage_projection(self, opponent) <= 0
  end

  # Estimated damage dealing
  def damage_projection(attacker, victim)
    strength(attacker) - defense(victim)/2
  end

  # Players in the game other then self
  def opponents
    Game.world[:players].select {|p| p != self}
  end

  def health(p = self)
    p.stats[:health]
  end

  def strength(p = self)
    p.stats[:strength]
  end

  def experience(p = self)
    p.stats[:experience]
  end

  def defense(p = self)
    p.stats[:defense]
  end

end
