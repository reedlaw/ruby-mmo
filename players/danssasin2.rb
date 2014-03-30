module Danssasin2
	def move
		if find_teeler
			[:attack, find_teeler ]
		else
			[:rest]
		end
	end

	def find_teeler
		Game.world[:players].select {|p| p.to_s == 'Teeler'}.first
	end
end