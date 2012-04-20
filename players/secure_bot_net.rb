# identification secrets
secrets = (1..(10 + rand(10)).map { rand(100000) }
secrets_length = secrets.length
random_name = (1..10).map { rand(100).chr }.join

# will be used for the eval string so that secrets and initial_contact_password_resolve
context = binding
# template
module SecuBot

  def self.extended(base)
    base.instance_variable_set :@friends, []
    base.instance_variable_set :@challengers, Hash.new(0)
    base.instance_variable_set :@enemies, []
  end
  
  def to_s
    random_name + ((1..rand(5)).map { rand(100).chr }.join)
  end
  
  def move
    redefine_move
  end
  
  def redefine_move
    all_players = Game.world[:players].reject {|p| p == self || @friends.include?(p) || @enemies.include?(p)}
    tagged_players = all_players.map {|p| [p, rand(secrets_length)]}
    # see who responds to challenge
    tagged_players.select! do |pair| 
      if pair[0].respond_to?(:challenge) # need to consider anyone that will respond to :challenge
        true
      else # everyone else is an enemy
        @enemies << pair[0]
        false
      end
    end
    # the ones that do respond to challenge requests can be challenged so challenge them
    tagged_players.select do |pair|
      player, req = pair
      if verify(req, player.challenge(req, self))
        @friends << player
        # send a friend request
        new_req = rand(secrets_length)
        corresponding_secret = secrets[new_req]
        player.friend_request(new_req, corresponding_secret, self)
      else # if not then they are an enemy
        @enemies << player
      end
    end
    # whoever we challenged is either already an enemy or a friend
    # so we are no longer going to get any challenge requests or send out friend requests
    remove_instance_variable :@challengers # remove reference to challengers
    class << self
      undef_method :verify # don't let in any verify requests
      undef_method :challenge # don't let in any challenge requests
      undef_method :friend_request # no more friend requests
      
      # we now define a coordination function to let our friends set targets
      def coordinate(target, requester)
        if @friends.include?(requester) # the request is by a friend so we accept
          @target = target
        end
      end
      
      def move
        # filter our friends and enemies down to players that are still alive
        @friends.select! {|friend| friend.alive?}
        @enemies.select! {|enemy| enemy.alive?}
        if @target && @target.alive? # target is alive so attack
          [:attack, @target]
        else
          if (new_target = find_new_target) # find somebody we can kill
            @target = new_target
            @friends.each {|friend| friend.coordinate(new_target, self)}
            [:attack, new_target]
          else
            [:rest]
          end
        end
      end
      
      def find_new_target
        # find somebody we can collectively kill in 1 hit or 2 hits
        # if there is no such player then either rest or attack somebody randomly
        collective_strength = self.stats[:strength] + \
          @friends.reduce(0) {|acc, friend| acc + friend.stats[:strength]}
        health_cache = Hash.new
        defense_cache = Hash.new
        @enemies.sort! do |a,b| 
          a_hp, a_def = (health_cache[a] ||= a.stats[:health]), (defense_cache[a] ||= a.stats[:defense])
          b_hp, b_def =(health_cache[b] ||= b.stats[:health]), (defense_cache[b] ||= b.stats[:defense])
          [a_hp, a_def] <=> [b_hp, b_def]
        end
      end
    end
  end
  
  # super secret way of performing challenge verifications
  def verify(req, answer, player)
    @challengers[player][req,answer]
  end
  
  # we request to see the player because we want to track how often they have challenged us
  def challenge(challenge_req, player)
    if !@challengers[player] # every player gets only 1 challenge request
      verification_closure = lambda do |req,answer|
        @challengers[player] = lambda {|q,a| false}
        secrets[req] == answer
      end
      @challengers[player] = verification_closure
      secrets[challenge_req]
    else # this person tried to challenge us more than once, so automatically an enemy
      @enemies << player
    end
  end
  
  def friend_request(req, answer, player)
    # we got a friend request and the data was correct so add the player to friends
    if verify(req, answer)
      @friends << player
    else # didn't provide the right data so automatically an enemy
      @enemies << player
    end
  end
  
end
