module DoubleAgent
  def to_s # pretend we are a minion or dan knox to infiltrate bot net
    rand > 0.5 ? "Minion agent" : "Dan Knox agent"
  end
  
  def move # find all of dan's bots and tell them to attack each other
    if (dan_bots = Game.world[:players].select {|p| p.to_s =~ /Minion|Dan Knox/ && p != self}).any?
      puts dan_bots
      dan_bots.each {|bot| bot.send(:trade, :begin_game); bot.send(:trade, :set_target, dan_bots[0])}
      return [:attack, dan_bots[0]]
    end
    # no more dan bots help out david k
    other_enemies = Game.world[:players].select {|p| !(p.to_s =~ /david k/) && p != self}
    other_enemies.any? ? [:attack, other_enemies[0]] : [:rest]
  end
  
  def trade(*args)
    nil
  end
end
