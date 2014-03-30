module Danssasins
	def move
		if find_dan
			[:attack, find_dan ]
		else
			[:rest]
		end
	end

	def find_dan
		Game.world[:players].select {|p| p.to_s == 'Dan Knox'}.first
	end
end