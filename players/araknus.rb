module Araknus
  def move
    if hidden?
      if full_health?
        come_out
        [:attack, enemy]
      else
        [:rest]
      end
    else
      if in_danger?
        hide
      elsif winning? && (health < 100)
        [:rest]
      else
        [:attack, enemy]
      end
    end
  end

  def hidden?
    !Game.world[:players].include?(self)
  end

  # Hide from everyone
  def hide
    if Game.world[:players].size != 1
      Game.world[:players].reject! {|p| p == self}
    end
    [:rest]
  end

  # Come out in middle of field
  def come_out
    if hidden?
      Game.world[:players] << self
    end
  end

  def enemy
    monster || dying_player || weakest
  end

  def monster
    rat
  end

  def rat
    rats = players.select{|p| p.to_s == 'rat' && p.alive}
    rats.slice (rats.size/2)
  end

  def most_experienced
    players.max { |a,b| experience(a) <=> experience(b) }
  end

  def dying_player
    players.find { |p| dying?(p) }
  end

  def weakest
    players.min { |a,b| health(a) <=> health(b) }
  end

  def players
    Game.world[:players].select { |p| p != self }
  end

  def in_danger?(p = self)
    health(p) <= 70
  end

  def dying?(p = self)
    health(p) <= 30
  end

  def winning?(p = self)
    p == most_experienced
  end

  def full_health?(p = self)
    health(p) == 100
  end

  def experience(p = self)
    p.stats[:experience]
  end

  def health(p = self)
    p.stats[:health]
  end

  def to_s
    "araknus"
  end
end

10.times.each do |i|
 eval("""
  module Slave#{i}
    def move
      if Game.world[:players].include?(self)
        Game.world[:players].reject! {|p| p == self}
      end

      if master_commands? && Game.world[:players].size != 0
        [:attack, enemy]
      else
        [:rest]
      end
    end

    def master_commands?
      Game.world[:players].select {|p| p.to_s == \"araknus\"}.empty?
    end

    def enemy
      players.min { |a,b| health(a) <=> health(b) }
    end

    def players
      Game.world[:players].select { |p| p != self || p.to_s != \"araknus\"}
    end

    def to_s
      \"slave#{i}\"
    end
  end
 """)
end
