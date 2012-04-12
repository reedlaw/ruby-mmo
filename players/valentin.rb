module Valentin

  def to_s
    "Valentin"
  end

  def move

    return [:attack, kill] unless kill.nil?

    best_opponent = opponents.max { |a, b| a.stats[:experience] <=> b.stats[:experience] }
    in_advantage = self.stats[:experience] > best_opponent.stats[:experience]

    if self.stats[:health] <= opponents.count * points && in_advantage
      return [:rest]
    end

    weakest_opponent = opponents.max { |a, b| a.stats[:health] <=> b.stats[:health] }
    return [:attack, weakest_opponent] unless weakest_opponent.nil?
  end

  private

  def points
    stats[:strength] - stats[:defense]/2
  end

  def kill
    opponents.select{|p| p!=self}.select{|p| killable? p}.first
  end

  def killable? player
    player.stats[:health] <= points
  end

  def opponents
    Game.world[:players].select{|p| p!=self}
  end
end
