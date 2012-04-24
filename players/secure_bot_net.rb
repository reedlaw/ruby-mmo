# registry
registry = Object.new
registry.instance_variable_set :@registry, []
class << registry
  def register(player)
    @registry << player unless @registry.include?(player)
  end
  
  def friends(caller)
    @registry.reject {|friend| friend == caller || !friend.alive?}
  end
  
  def chuck(target)
    friends(nil).each {|friend| friend.instance_variable_set :@target, target}
  end
end

# will be used for the eval string so that identification secrets resolve
context = binding

template = <<-EOF
module SecuBotNumberGoesHere
end

SecuBotNumberGoesHere.module_eval do
  
  def self.extended(base)
    base.instance_variable_set :@target, nil
  end
  
  self.instance_eval do
    define_method(:to_s) do
      (1..rand(5)).map { rand(100).chr }.join
    end
    
    define_method(:move) do
      registry.register(self)
      if @target && @target.alive?
        [:attack, @target]
      else
        find_new_target
        if @target
          my_hp = stats[:health]
          if my_hp >= 90
            [:attack, @target]
          elsif my_hp >= 60 && (enemy = Game.world[:players].reject {|p| p == self || friends.include?(p)})[0]
            [:attack, enemy]
          else
            [:rest]
          end
        else
          [:rest]
        end
      end
    end
    
    define_method(:find_new_target) do
      friends = registry.friends(self)
      collective_strength = friends.map {|f| f.stats[:strength]}.reduce(self.stats[:strength]) do |acc,f| 
        acc + f
      end
      enemies = Game.world[:players].reject {|p| friends.include?(p) || p == self}
      hp = {}
      enemies.sort! {|a,b| (hp[a] ||= a.stats[:health]) <=> (hp[b] ||= b.stats[:health])}
      enemies.select! {|e| (hp[e] || 0) <= (collective_strength - e.stats[:defense] / 2)}
      registry.chuck(enemies[0])
    end
    
  end
  
end
EOF

(0..2).each {|n| eval template.gsub('NumberGoesHere', n.to_s), context}
