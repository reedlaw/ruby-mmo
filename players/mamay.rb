module Mamay

	def to_s
		"Cossack Mamay"
	end

	def move
		if need_a_rest? or already_winner?
			[:rest]	
		elsif weak
			[:attack, weak]
		else	
			[:attack, rats.first]
		end	
	end
	
	protected

	def humans
		Game.world[:players].select{|p| p != self and p.to_s !='rat'}
	end

	def rats
		Game.world[:players].select{|p| p.to_s =='rat'}
	end

	def need_a_rest?
		stats[:health] < (humans.count/2)*10
	end

	def already_winner?
		stats[:experience] > humans.sort_by{|h| h.stats[:experience]}.last.stats[:experience]
	end	

	def weak
		humans.detect do |h|
		  h.stats[:health] <= (stats[:strength] - (h.stats[:defense] / 2))
		end 
	end	

end