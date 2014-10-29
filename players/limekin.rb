module OwningTimeLOL

    def to_s
	"limekin"
    end

    def move

	@players = sort_by_health( get_alive_players ) 
	@monsters = sort_by_health( get_alive_monsters ) 

	if self_last_hit? 
	    return [:rest]
	else
	    opponent = second_killable_player || second_killable_monster || strongest_player || strongest_monster
	    [:attack, opponent]
	end
    end

    
    def get_alive_players
	(Game.world[:players] || []).select do |player|
	    player.alive? and player != self
	end
    end

    def get_alive_monsters
	(Game.world[:monsters] || []).select do |monster|
	    monster.alive?
	end
    end

    def sort_by_health(opponents)
	opponents.sort_by do |opponent|
	    fs( opponent, :max_health )
	end
    end
	
    def self_last_hit?
	(@players + @monsters).any? do |opponent|
	    fs(opponent, :strength) - fs(self,:defense)/2 == @health
	end
    end

    def second_killable_player
	killable_players = @players.select do |player|
	    fs(player, :health) == fs(self,:strength) - fs(player, :defense)/2
	end || []
	killable_players[1]
    end

    def second_killable_monster
	killable_monster = @monsters.select do |monster|
	    fs(monster, :health) == fs(self, :strength) - fs(monster, :defense)/2
	end || []
	killable_monster[1]
	
    end

    def strongest_player
	@players[0]
    end

    def strongest_monster
	@monsters[0]
    end

    def fs(opponent, attr)
	opponent.stats[attr]
    end


end
