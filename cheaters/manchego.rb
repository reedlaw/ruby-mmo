module Manchego
  def to_s
    "Count Manchego"
  end

  # I AM A VAMPIRE
  def alive
    false
  end

  def move
    action = if killable_enemies.size > 0
               [:attack, killable_enemies.first]
             elsif stats[:health] < 90
               [:rest]
             elsif self == apex_predator
               [:attack, weakest_prey]
             else
               [:attack, apex_predator]
             end
    return action
  end
  
  def players
    Game.world[:players]
  end

  def enemies
    players.select { |p| p != self }
  end

  def apex_predator
    players.sort_by { |e| -e.stats[:experience] }.first
  end

  def weakest_prey
    enemies.sort_by { |e| e.stats[:health] }.first
  end

  def killable_enemies
    enemies.select { |enemy| killable?(enemy) }.sort_by { |e| -e.stats[:experience] }
  end

  def killable?(player)
    damage_vs(player) >= player.stats[:health]
  end

  def damage_vs(player)
    stats[:strength] - (player.stats[:defense] / 2)
  end
end
