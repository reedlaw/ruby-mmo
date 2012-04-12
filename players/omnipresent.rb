module Omnipresent
  RISKY_HEALTH_LEVEL = 30
  DONT_GET_GANGED_UP = 60
  GOOD_HEALTH = 90
  PREV_WORST_HEALTH = 100
  def move
    return [:attack, confirm_dead_after_attack[0]] unless confirm_dead_after_attack[0].nil?

    return play_aggressive if (stats[:health] > GOOD_HEALTH && current_spot != 0)

    return show_fight if (stats[:health] <= DONT_GET_GANGED_UP && current_spot == 0)

    #always fight when its a TRUEL!
    return always_fight if (others.size == 3) && (stats[:health] > DONT_GET_GANGED_UP)

    [:rest]
  end

  def to_s
    "Chuck Norris"
  end

  private 
 
  def show_fight
    [:attack, sort_by_health[0]]
  end

  def play_aggressive 
    @attack = false
    prev_worst_health= PREV_WORST_HEALTH
    others.each do |other|
      worst_health_of_player = other.stats[:health] - opponent_health_after_my_attack(other)
      my_loss = health_i_would_lose(other)
      if (worst_health_of_player < prev_worst_health && more_exp_than_me?(other) )
        prev_worst_health = worst_health_of_player
        @opponent = other
        @attack = true
      end
    end
    if @attack && !risky_health_level? 
      [:attack, @opponent]
    else
      [:rest] 
    end
  end

  def more_exp_than_me?(other)
    other.stats[:experience] >= stats[:experience]
  end
  def current_spot
    sort_by_experience.index{|other| other.to_s =~ /Chuck Norris/}
  end
  def sort_by_experience
    Game.world[:players].sort{|a,b| b.stats[:experience]<=>a.stats[:experience]}
  end
  def sort_by_health
    others.sort{|a,b| a.stats[:health]<=>b.stats[:health]}
  end
  def risky_health_level?
    stats[:health] <= RISKY_HEALTH_LEVEL
  end
  def others 
    Game.world[:players].select { |player| player != self }
  end
  def points_if_attack(other)
    stats[:strength] - other.stats[:defense]/2
  end
  def confirm_dead_after_attack
    others.select{|other| opponent_health_after_my_attack(other) <= 0}
  end
  def opponent_health_after_my_attack(other)
    other.stats[:health] - points_if_attack(other)
  end
  def health_i_would_lose (other)
    stats[:health] - points_if_attack(other)
  end
end
