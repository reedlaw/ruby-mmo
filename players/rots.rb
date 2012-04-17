module Rots
	def to_s
		"rots"
	end
	
	def move
		player_count = Game.world[:players].count
		opponent = Game.world[:players].select{|p|p != self}[rand(player_count - 1)]
		#opponent.stats
		if self.stats[:health] < 100 then [:rest] else
			if rand(10) < 10 then [:attack, player_with_lowest_health] else [:rest] end
		end
	end
	
	def player_with_lowest_health
		all_players_not_me = Game.world[:players].select{|p| p !=self}
		all_players_not_me.sort_by{|player| player.stats[:health]}.first
	end
end 
