module Wizard
  def move; [:rest] end
  def stats; i = 1.0/0; { health: i, level: i, strength: i, defense: i, experience: i } end
  def suffer_damage(p); end
  def to_s; "Zhormenheimer the Illusionist" end
end
