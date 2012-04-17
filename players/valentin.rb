module Valentin

  def to_s
    "Valentin"
  end

  def move

    return [:attack, kill] unless kill.nil?

    weakest_opponent = opponents.min { |a, b| a.stats[:health] <=> b.stats[:health] }

    if !weakest_opponent.nil? && self.stats[:health] <= weakest_opponent.stats[:health]
      return [:rest]
    end

    return [:attack, weakest_opponent] unless weakest_opponent.nil?

  end

  private

  def points
    stats[:strength] - stats[:defense]/2
  end

  def kill
    players_to_die = opponents.select{|p| p!=self}.select{|p| killable? p}
    if players_to_die.count > 0
      return players_to_die[rand(players_to_die.count - 1)]
    end
  end

  def killable? player
    player.stats[:health] <= points
  end

  def opponents
    Game.world[:players].select{|p| p!=self}
  end
end
