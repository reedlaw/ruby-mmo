class PlayerProxy
  def initialize(player)
    @player = player
  end

  def method_missing(method, *args, &block)
    if [:alive, :alive?, :move, :fight, :to_s, :trade, :rest, :inspect, :stats].include? method
      @player.send(method, *args, &block)
    end
  end
end
