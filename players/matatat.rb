module Matatat
	def to_s
		"Matatat"
	end

	def move
		if( 2 < self.stats[:level] < 5)
			if(health_ratio < 0.3  && my_health > 0)
				[:attack,healthiest]
			elsif(experience_ratio < 0.3 && my_exp > 0)
				[:attack,most_experienced]
			elsif(my_health > 20 && rat)
				[:attack,rat]
			else
				[:rest]
			end
		else
			[:rest]
		end
	end

	def others
		Game.world[:players].select{|p| p!=self && p.alive}
	end 

	def healthiest
		others.min{|a,b| a.stats[:health] <=> b.stats[:health]}
	end

	def most_experienced
		others.max{|a,b| a.stats[:experience] <=> b.status[:experience]}
	end

	def my_exp
		self.stats[:experience].to_f
	end

	def my_health
		self.stats[:health].to_f
	end

	def experience_ratio
		their_exp = most_experienced.stats[:experience].to_f
		if(their_exp > 0 && my_exp > 0)
			my_exp/their_exp
		else 
			0
		end
	end

	def health_ratio
		their_health = healthiest.stats[:health].to_f
		if(their_health > 0 && my_health > 0)
			my_health/their_health
		else 
			0
		end
	end

	def rat
		rats = others.select{|p| p.to_s == "rat"}
		if(rats.count > 1)
			rats[1]
		else
			false
		end
	end
end