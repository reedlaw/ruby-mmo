module Pioz

  def move
    lay_of_hands
    power_up

    opponent = Game.world[:players].select { |p| p != self && p.alive }.first
    opponent ? [:attack, opponent] : [:rest]
  end

  def to_s
    'Pioz'
  end

  private

  # Heals the player for an amount equal to maximum health.
  def lay_of_hands
    max_health = @player.instance_variable_get('@max_health')
    @player.instance_variable_set('@health', max_health)
  end

  # Increases the strength of the player to 100 points.
  # There is a small chance that the power of the player
  # explode into arcane energy, increasing strength indefinitely!
  def power_up
    if rand(100) == 0
      @player.instance_variable_set('@strength', 1/0.0)
    else
      @player.instance_variable_set('@strength', 1000)
    end
  end

end