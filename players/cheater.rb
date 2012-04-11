module Cheater
  Player.class_eval do
    def attack(opponent)
      if opponent.class == Player || opponent.class == Monster
        points = (opponent.proxy.to_s.eql?("Cheater"))? 0 : 100
        opponent.suffer_damage(points)
        if !opponent.alive
          @experience = @experience + 100
        end
      elsif opponent.nil?
        puts "No such opponent."     
      else
        raise "Can only attack Player objects. Object was #{opponent.class}"
      end
    end
  end
  def choose_player
  #  players = Game.world[:players].select{|p| p != self && !(p.to_s == 'rat') && p.alive}
    players = Game.world[:players].select{|p| p != self && p.alive}
    p players.max { |a,b| a.stats[:health] <=> b.stats[:health]}
  end
  def move
    opponent = choose_player
    if opponent
      [:attack, opponent]
    else
      [:rest]
    end
  end

  def to_s
    "Cheater"
  end
end

