module Chandler
  OUNCE_OF_STRENGTH = 50
  def to_s
    "*No rest for the wicked*"
  end

  def move
    if ounce_of_strength_left_in_me?
      [:attack, most_wicked_player]
    else
      [:rest] unless most_wicked_player == self #norest
    end
  end
  
  def ounce_of_strength_left_in_me?
    stats[:health] >= OUNCE_OF_STRENGTH
  end
  
  def most_wicked_player
    opponents = Game.world[:players].select{ |player| player != self}
    opponents.sort!{|a,b| a.stats[:experience] <=> b.stats[:experience]}.first
  end
end