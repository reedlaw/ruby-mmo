module Emmanuel

	def to_s
		"Emmanuel, the new guy"
	end

	def move	
		# sleep 0.5
		if hp_danger? && opponents.length >= 5 || top_3
			[:rest]
		else
			[:attack, attack_sequence]
		end
	end

	private 

	# find players with lowest stats, pick off the weak
	def rest_conditions
		hp_danger? && opponents.length >= 5 || top_3
	end

	def attack_sequence
		can_kill ? can_kill : leader
	end

	def hp_danger?
		self.stats[:health] < 90
	end

	def top_3
		
		top_3_xp.include?(self.to_s)
	end

	def top_3_xp
	 opponents_array = all_players.sort { |a, b| b.stats[:experience] <=> a.stats[:experience] }.take(opponents.length/2)
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

	def lowest_xp
		opponents.min_by {|opponents| opponents[:experience]}
	end

	def lowest_hp
		opponents.min_by {|opponents| opponents[:health]}
	end	

	def monsters
		opponents.select {|p| p.to_s == 'rat'}
	end

	def opponents 
		Game.world[:players].select {|p| p != self}
	end

	def all_players
		Game.world[:players]
	end
end