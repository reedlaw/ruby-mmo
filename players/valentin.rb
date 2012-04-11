module Valentin
  def to_s
    "Valentin"
  end
  def move
    max_health = 100
    points  = self.stats[:strength] - self.stats[:defense]/2

    kill = Game.world[:players].select{|p| p!=self && p.stats[:health] <= points && p.alive}.first
    return [:attack, kill] unless kill.nil?

    opponents = Game.world[:players].select{|p| p!=self && p.alive && p.to_s != 'rat'}

    best_opponent = opponents.max { |a, b| a.stats[:experience] <=> b.stats[:experience] }
    in_advantage = self.stats[:experience] > best_opponent.stats[:experience]

    if self.stats[:health] <= opponents.count * points && in_advantage
      return [:rest]
    end

    weakest_opponent = opponents.min { |a, b| a.stats[:health] <=> b.stats[:health] }
    return [:attack, weakest_opponent] unless weakest_opponent.nil?
  end
end
