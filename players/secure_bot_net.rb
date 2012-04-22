require 'pry'
# identification secrets
secrets = (1..(10 + rand(10))).map { rand(100000) }
secrets_length = secrets.length
random_name = (1..10).map { rand(100).chr }.join
attack_message = rand(1000000)
rest_message = rand(1000000)

# will be used for the eval string so that secrets and initial_contact_password_resolve
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
      rand(100).chr + random_name + ((1..rand(5)).map { rand(100).chr }.join)
    end
    
    define_method(:move) do
      if @target && @target.alive?
        [:attack, @target]
      else
        @target, friends = find_new_target
        random_key = rand(secrets_length)
        friends.each {|f| f.set_target(attack_message ^ secrets[random_key], random_key, @target)}
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
      friends = identify_friends
      collective_strength = friends.map {|f| f.stats[:strength]}.reduce(self.stats[:strength]) do |acc,f| 
        acc + f
      end
      enemies = Game.world[:players].reject {|p| friends.include?(p) || p == self}
      hp = {}
      enemies.sort! {|a,b| (hp[a] ||= a.stats[:health]) <=> (hp[b] ||= b.stats[:health])}
      enemies.select! {|e| hp[e] <= (collective_strength - e.stats[:defense] / 2)}
      return enemies[0], friends
    end
    
    define_method(:identify_friends) do
      possible_friends = Game.world[:players].select {|p| p != self}
      possible_friends.select! {|p| p.respond_to? :iff}
      possible_friends.select do |p| 
        random_key = rand(secrets_length)
        message, key_index = p.iff(rest_message ^ secrets[random_key], random_key)
        (message ^ secrets[key_index]) == attack_message
      end
    end

    define_method(:iff) do |message, key_index|
      if (message ^ secrets[key_index]) == rest_message
        random_key = rand(secrets_length)
        return attack_message ^ secrets[random_key], random_key
      else
        nil
      end
    end
  
    define_method(:set_target) do |message, key_index, target|
      if (message ^ secrets[key_index]) == attack_message
        @target = target
      end
    end
    
  end
  
end
EOF

(0..2).each {|n| eval template.gsub('NumberGoesHere', n.to_s), context}
