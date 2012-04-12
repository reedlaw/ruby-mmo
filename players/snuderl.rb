module Snuderl
	def move
		if ranking < 3 and health < 70
			[:rest]
		end
		if health<65
			return [:rest]
		end
		if dying.first
			[:attack, dying.first]
		end
		opponent = weak.first
		if opponent.alive
			[:attack, opponent]
		elsif  health==100
			[:attack, enemies[rand(player_count-1)]]
		else
			[:rest]
		end

	end

	def ranking
		Game.world[:players].sort{|a,b| a.stats[:experience] <=> a.stats[:experience]}.reverse.index(self)
	end


	def to_s
		"Mighty Snuderl"
	end

	def weak
		enemies.select{|e|e.alive}.sort{ |a,b| a.stats[:health] <=> b.stats[:health]}
	end

	def dying
		enemies.select{|a| a.stats[:health] <= 30}
	end

	def enemies
		Game.world[:players].select{|p| p!= self}
	end

	def health
		self.stats[:health]
	end


end