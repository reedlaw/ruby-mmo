# identification secrets
secrets = (1..(10 + rand(10)).map { rand(100000) }
secrets_length = secrets.length
random_name = (1..10).map { rand(100).chr }.join
attack_message = rand(1000000)
rest_message = rand(1000000)

# will be used for the eval string so that secrets and initial_contact_password_resolve
context = binding

# template
template = <<EOF-
module SecuBotNumberGoesHere
  
  def self.extended(base)
    base.instance_variable_set :@target, nil
  end
  
  def to_s
    random_name + ((1..rand(5)).map { rand(100).chr }.join)
  end
  
  def move
    if @target && @target.alive?
      [:attack, @target]
    else
      @target, friends = find_new_target
      random_key = rand(secrets_length)
      friends.each {|f| f.set_target(attack_message ^ secrets[random_key], random_key, @target)}
      if @target && stats[:health] >= 90
        [:attack, @target]
      elsif stats[:health] >= 60
        [:attack, Game.world[:players].reject {|p| p == self || friends.include?(p)}[0]]
      else
        [:rest]
      end
    end
  end
  
  def find_new_target
    friends = identify_friends
    collective_strength = friends.map {|f| f.stats[:strength]}.reduce(self.stats[:strength]) do |acc,f| 
      acc + f.stats[:strength]
    end
    enemies = Game.world[:players].reject {|p| friends.include?(p) || p == self}
    hp = {}
    enemies.sort! {|a,b| (hp[a] ||= a.stats[:health]) <=> (hp[b] ||= b.stats[:health])}
    enemies.select! {|e| hp[e] <= (collective_strength - e.stats[:defense] / 2)}
    return enemies[0], friends
  end
  
  def identify_friends
    possible_friends = Game.world[:players].select {|p| p != self}
    all_players.select! {|p| p.respond_to? :iff}
    random_key = rand(secrets_length)
    all_players.select do |p| 
      message, key_index = p.iff(rest_message ^ secrets[random_key], random_key)
      (message ^ secrets[key_index]) == attack_message
    end
  end
  
  def iff(message, key_index)
    if (message ^ secrets[key_index]) == rest_message
      random_key = rand(secrets_length)
      return attack_message ^ secrets[random_key], random_key
    else
      nil
    end
  end
  
  def set_target(message, key_index, target)
    if (message ^ secrets[key_index]) == attack_message
      @target = target
    end
  end
end
EOF

(0..2).each {|n| eval template.sub('NumberGoesHere', n.to_s), context}
