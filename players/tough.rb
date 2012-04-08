module Tough
  def move
    opponent = Game.world[:players].select {|p| p != self.proxy }.first
    [:fight, opponent]
  end

  def to_s
    "Sir Samsonite"
  end
end
