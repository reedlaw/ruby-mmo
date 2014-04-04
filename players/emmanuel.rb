module Emmanuel

	def to_s
		"Emmanuel, the new guy"
	end

	def move	
		if rest_conditions
			[:rest]
		else
			[:attack, attack_sequence]
		end
	end

	private 

	def rest_conditions
		hp_danger? && opponents.length >= 3 || top_quarter
	end

	def attack_sequence
		can_kill ? can_kill : leader
	end

	def hp_danger?
		self.stats[:health] < 90
	end

	def top_quarter
		top_quarter_xp.include?(self.to_s)
	end

	def top_quarter_xp
		opponents_array = all_players.sort { |a, b| b.stats[:experience] <=> a.stats[:experience] }.take(opponents.length/4)
		strings = opponents_array.map(&:to_s)
	end

	def leader
		opponents.max_by { |p| p.stats[:experience]}
	end
	
	def can_kill
			opponents.select{ |p| damage_to_kill(p) }.sample
	end

	def damage_to_kill(opponent)
		(self.stats[:strength] - opponent.stats[:defense] / 2) >= opponent.stats[:health]
	end

	def opponents 
		Game.world[:players].select {|p| p != self}
	end

	def all_players
		Game.world[:players]
	end

end