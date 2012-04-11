module Jurek
  def choose_rat
    Game.world[:players].select{|p| p.to_s == 'rat' }.first
  end
  def choose_player
    players = Game.world[:players].select{|p| p != self }
    players.min { |a,b| a.stats[:health] <=> b.stats[:health] }
  end
  def in_danger?
    self.stats[:health] <= 50
  end
  def dying?
    self.stats[:health] <= 30
  end
  def find_dying_players
    Game.world[:players].select { |p| (p.stats[:health] <= 30) && p != self }
  end
  def move
    opponent = (choose_rat.nil?)? choose_player : choose_rat

    if players = find_dying_player
      unless in_danger?
        opponent = players.min { |a,b| a.stats[:health] <=> b.stats[:health] }
      end
    end

    if opponent && opponent.alive && not(dying?)
      [:attack, opponent]
    else
      [:rest]
    end
  end

  def to_s
    "Jurek"
  end
end

