module Jbttn
  def move
    if stats[:health] >= 100 && !am_i_leading?
      attack
    else
      [:rest]
    end
  end

  def to_s
    "Jbttn"
  end
  
  private
  
    def everyone
      Game.world[:players].select{ |p| p.alive }
    end
    def leaders
      everyone.sort!{ |a,b| a.stats[:experience] <=> b.stats[:experience] }
      everyone.take(5)
    end
    def opponents
      Game.world[:players].select{ |p| p != self && p.alive }
    end
    
    def attack
      weakling = weakest
      strongling = strongest
      random_dying = dying_opponents.shuffle.first
      
      if random_dying
        [:attack, random_dying]
      else
        [:attack, weakest]
      end
    end
    
    def weakest
      sorted = opponents.sort_by { |p| p.stats[:health] }
      sorted.first
    end
    def strongest
      opponents.max { |a,b| a.stats[:experience] <=> b.stats[:experience] }
    end
    
    def weaker_than?(opponent)
      stats[:health] < opponent.stats[:health]
    end
    def stronger_than?(opponent)
      stats[:health] > opponent.stats[:health]
    end
    
    def dying?(player)
      player.stats[:health] < 20
    end
    def dying_opponents
      opponents.find_all { |p| dying?(p) }
    end
    
    def am_i_leading?
      in_lead = leaders
      in_lead.include?(self)
    end
end