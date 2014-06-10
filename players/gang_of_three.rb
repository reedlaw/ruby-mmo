class GangOfThree
  attr_accessor :current_victim
  attr_reader :last_victim
  
  def initialize
    @members = []
    @names = %w(Clotho Lachesis Atropos)
    reset
  end
  
  def form_up
    3.times {create_member @names.shift} unless @members.any?
  end
  
  def kill?(player)
    defense = player.stats[:defense] / 2
    total_damage = members.inject(0) do |sum, member|
      sum + member.strength - defense
    end
    total_damage > player.stats[:health]
  end
  
  def max_health(player)
    Player::HEALTH_INDEX[player.stats[:level]]
  end
  
  def members
    @members.select {|m| m.alive?}
  end
  
  def monsters
    @monsters ||= begin
      all_players.select {|p| p.to_s == 'rat'}
    end
  end
  
  def move_taken(member)
    @moves << member
    reset if @moves.size == members.size
  end
  
  def proxies
    @proxies ||= members.map {|m| m.proxy}
  end
  
  def victims
    @victims ||= begin
      players = all_players.reject {|p| p.to_s == 'rat'}
      players.sort_by {|p| [1/max_health(p), p.stats[:health]]}
    end
  end
  
  protected
    def all_players
      Game.world[:players].reject {|p| proxies.include? p}
    end
    
    def create_member(name)
      @members << Member.new(name, self).tap do |m|
        m.prepare
      end
    end
    
    def reset
      @moves = []
      @last_victim = @current_victim
      @last_victim = nil if @last_victim && !@last_victim.alive?
      @current_victim = nil
      @victims = nil
      @monsters = nil
    end
  
  class Member
    attr_reader :name, :gang, :module
    attr_accessor :proxy
    
    def initialize(name, gang)
      @name = name
      @gang = gang
    end
    
    %w(health strength experience).each do |m|
      define_method m do
        proxy.stats[m.to_sym]
      end
    end
    
    %w(alive? stats).each do |m|
      define_method m do
        proxy.send m
      end
    end
    
    def move
      return rest if winning? || vulnerable?
      
      victim = next_victim
      if victim
        attack victim
      else
        health == max_health ? attack(random_victim) : [:rest]
      end
    ensure
      gang.move_taken self
    end
    
    def prepare
      create_module
    end
    
    protected
      def attack(victim)
        [:attack, victim]
      end
      
      def vulnerable?
        !gang.victims.detect {|v| kill? self, v}.nil?
      end
      
      def kill?(victim, attacker = self)
        total_damage = attacker.stats[:strength] - victim.stats[:defense] / 2
        total_damage > victim.stats[:health]
      end
      
      def max_health(p = proxy)
        gang.max_health p
      end
      
      def next_victim
        current = gang.current_victim
        return current if current
        
        last_victim = gang.last_victim
        return gang.current_victim = last_victim if last_victim && last_victim.alive?
        
        easy_victim = gang.victims.detect {|v| gang.kill? v}
        return gang.current_victim = easy_victim if easy_victim
        
        easy_victim = gang.victims.detect {|v| kill? v}
        return easy_victim if easy_victim
        
        monster = random_monster
        return monster if monster
        
        gang.current_victim = random_victim
      end
      
      def random_monster
        gang.monsters.sample
      end
      
      def random_victim
        gang.victims.sample
      end
      
      def rest
        [:rest]
      end
      
      def winning?
        return false if experience < 50
        return false if gang.victims.size < 10
        top_three = (gang.victims + [self]).sort_by {|v| v.stats[:experience]}[-3..-1]
        top_three && top_three.include?(self)
      end
    
    private
      def create_module
        @module = Module.new do
          def move
            member.move
          end
          
          def to_s
            member.name
          end
        end
        
        Object.const_set name, @module
        class << @module
          attr_accessor :member, :name
          
          def extended(player_proxy)
            class << player_proxy
              attr_accessor :member
            end
            player_proxy.member = member
            member.proxy = player_proxy
          end
        end
        @module.member = self
        @module.name = name
      end
  end
end

GangOfThree.new.form_up
