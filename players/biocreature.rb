module BioCreature

  def to_s
    "BioCreature"
  end

  def self.extended(base)
    base.instance_variable_set :@round, 0
  end

  def move
    @round += 1

    if should_fight?
      p "BioCreature is fighting"
      fight
    else
      p "BioCreature is recovering"
      recover
    end

  end

  private

  def kill
    if @round > 80
      leader
    else
      easy_players = opponents.select{|p| p!=self}.select{|p| easyKill? p}
      medium_players = opponents.select{|p| p!=self}.select{|p| killable? p}

      if easy_players.count > 0
        p "easy player loop"
        return easy_players[rand(easy_players.count - 1)]
      elsif medium_players.count > 0
        p "medium_players loop"
        return medium_players[rand(medium_players.count - 1)]
      end
    end

  end

    # player: the player that you want to know if is killable
    def killable? player
      opponentDamage = calcDamage(fromPlayer: player, toPlayer: self)
      selfDamage = calcDamage(fromPlayer: self, toPlayer: player)

      # if the TTK for myself is equal to my opponent then return true
      timeToKill(player: self, damage: opponentDamage) == timeToKill(player: player, damage: selfDamage)
      # note: if you are wondering why only equals, then look at easyKill
    end

    # player: the player that you want to know if is an easy kill
    def easyKill? player
      opponentDamage = calcDamage(fromPlayer: player, toPlayer: self)
      selfDamage = calcDamage(fromPlayer: self, toPlayer: player)

      # if the TTK for myself is longer than my opponent (not equal) then return true
      timeToKill(player: self, damage: opponentDamage) > timeToKill(player: player, damage: selfDamage)
    end

    # fromPlayer: the player that you want to know the damage for
    # toPlayer: the player that you want to possibly attack
    def calcDamage (fromPlayer: self, toPlayer: self)
      # Damage = Strength - Defense/2
      if self == fromPlayer
        self.stats[:strength] - toPlayer.stats[:defense]/2
      else
        fromPlayer.stats[:strength] - self.stats[:defense]/2
      end
    end

    # player: the player that you want to know the TTK for
    # damage: the damage of the player other than the :player
    def timeToKill (player: self, damage: 10)
      # Time-To-Kill = Health / Damage
      if player != self
        player.stats[:health]/damage
      else
        self.stats[:health]/damage
      end
    end

    def opponents
      Game.world[:players].select{|p| p!=self}
    end

    def recover
      p "BioCreature called recover"
      [:rest]
    end

    def leader
      opponents.max_by { |p| xp(p) }
    end

    def middle_of_pack
      opponents.sort_by! { |p| xp(p) }
      opponents[opponents.count/2]
    end

    def should_fight?
      if health >= 100 && @round < 10
        true
      elsif @round >= 80
        true
      elsif xp > xp(middle_of_pack)
        false
      else
        true
      end
    end

    def xp(p = self)
      p.stats[:experience]
    end

    def level(p = self)
      p.stats[:level]
    end

    def health(p = self)
      p.stats[:health]
    end

    #fight causing problems, previous code returns nil value as move. 
    # changed from [:attack, kill] unless.nil? 
    # to this conditional that always returns a move.  
    def fight
      
      kill.nil? ? [:recover] : [:attack]
      # unless kill.nil?
      #   [:attack, kill]
      # else 
      #   [:recover]
      # end
    end

  end
