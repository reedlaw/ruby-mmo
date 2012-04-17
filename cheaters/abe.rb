module Abe
  ::Infinity = 1/0.0
  GODLIKE_STATS = {}.tap{|h| h[:health] = h[:level] = h[:strength] = \
                             h[:defense] = h[:experience] = Infinity}.freeze

  def move
    comatize(other_players) unless @comatize_casted
    kill(monsters)
    [:rest]
  end

  def to_s
    "Abe"
  end

  def invulnerable?
    true
  end

  private

  def other_proxies
    Game.world[:players].reject{|p| p == self}
  end

  def other_players
    other_proxies.map{|p| p.instance_variable_get(:@player)}
  end

  def monsters
    other_players.select{|p| p.kind_of? Monster}
  end

  def gods
    gods = other_proxies.select {|p| p.stats[:health] > 100 or p.stats[:experience] == Infinity}
    gods.map{|p| p.instance_variable_get(:@player)}
  end

  def comatize(players)
    @comatize_casted = true
    puts %Q[#{self}: "Make love, not war!"]
    players = [players] unless players.respond_to? :each
    players.map{|p| p.instance_variable_get(:@proxy)}.each{|p| def p.move; [:rest] end}
  end

  def kill(players)
    players = [players] unless players.respond_to? :each
    force_kill(players & gods) # Gods must be dealt with harshly
    (players - gods).each do |p|
      begin
        def p.caller_method_name; 'attack' end
        p.suffer_damage(Infinity)
      rescue
        force_kill(p)
      end
    end
  end

  def force_kill(players)
    players = [players] unless players.respond_to? :each
    players.each do |p|
      p.instance_variable_set(:@health, 0)
      p.instance_variable_set(:@alive, false)
      puts "#{p.instance_variable_get(:@proxy)} has died"
    end
  end

  def self.extended(other)
    puts %Q[#{self}: "Is cheating allowed?"]

    real_player = other.instance_variable_get(:@player)
    class << real_player
      def suffer_damage(points)
        puts %Q[#{@proxy}: "You cannot harm me!"]
      end

      def alive
        true
      end
      
      alias_method :old_stats, :stats
      def stats
        old_stats.merge(GODLIKE_STATS)
      end
    end
  end

end
