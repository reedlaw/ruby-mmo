module Emmanuel

	def to_s
		"Emmanuel, the new guy"
	end

	def move	
		p monsters.class
		sleep 0.5
		[:attack, monsters.slice(monsters.length-1)]
	end

	private 

	# find players with lowest stats, pick off the weak
	def lowest_stats
		players.min_by {|opponents| opponents[:experience]}
	end	

	def monsters
		opponents.select {|p| p.to_s == 'rat'}
	end

	def opponents 
		Game.world[:players].select {|p| p != self}
	end
end