module RogueLeader
  def to_s
    "Rogue Leader"
  end

  def move
    return [:rest] if health < 30

    action = if killable_opponents.any?
                [:attack, killable_opponents.first]
             else
                [:attack, weakest_opponent]
             end
    action
  end

  private
  
  [:strength, :defense, :health].each do |method_name|
    define_method(method_name) do |player=self|
      player.stats[method_name]
    end
  end
 
  def opponents
    Game.world[:players].select { |p| not_me?(p) }
  end

  def not_me?(player)
    player != self
  end

  def opponents_by_weakness
    opponents.sort_by { |o| [defense(o), health(o)] }
  end

  def killable_opponents
    opponents_by_weakness.select { |o| can_kill?(o) }
  end

  def can_kill?(player)
    points = estimate_attack_damage(player)
    player.stats[:health] <= points
  end

  def estimate_attack_damage(player)
    strength - (defense(player) / 2)
  end

  def weakest_opponent
    opponents_by_weakness.first   
  end

  # IFF Horde
  def horde
    true
  end
end
