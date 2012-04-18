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
    base.instance_variable_set :@enemies
  end
  
  def to_s
    random_name + ((1..rand(5)).map { rand(100).chr }.join)
  end
  
  def move
    redefine_move
  end
  
  def redefine_move
    all_players = Game.world[:players].reject {|p| p == self || @friends.include?(p) || @enemies.include?(p)}
    # reject any enemies or freinds from consideration
    # assign random req/resp pairs to each player
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
    class << self
      undef_method :verify
      undef_method :challenge
      undef_method :friend_request
      
      define_method(:move) do
        
      end
    end
    # we also no longer need to track challengers
    remove_instance_variable :@challengers
    # we need to redefine move to do what we want it to do instead of repeating the above
  end
  
  # super secret way of performing challenge verifications
  def verify(req, answer)
    secrets[req] == answer
  end
  
  # we request to see the player because we are going to challenge the player as well
  def challenge(challenge_req, player)
    if (@challengers[player] += 1) == 1 # every player gets only 1 challenge
      secrets[challenge]
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
