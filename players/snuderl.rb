module Snuderl
	def move
		if health<65
			return [:rest]
		end
		opponent = weak.first
		if opponent.alive
			[:attack, opponent]
		else
			[:rest]
		end

	end

	def to_s
		"Mighty Snuderl"
	end

	def weak
		enemies.select{|e|e.alive}.sort{ |a,b| a.stats[:health] <=> b.stats[:health]}
	end

	def enemies
		Game.world[:players].select{|p| p!= self}
	end

	def health
		self.stats[:health]
	end


end