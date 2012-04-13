module Izidor

    def to_s
       "Izidor" 
    end

################## Game mechanics ################################################

    # I can't get these constant from API :-(
    MAX_HEALTH = 100
    REST_ADD = 10
    #
    # Select all live enemies
    def enemies
        Game.world[:players].select { |p| p != self && p.alive}
    end

    # Compute damage
    # (encapsulate attack formula)
    def damage(strength, defense)
        strength - defense / 2
    end
    
    # Compute the health after having rest
    # (encapsulate rest formula)
    def health_after_rest
        stats[:health] + REST_ADD
    end

    # Can player a kill player b in this turn?
    def can_kill?(a, b)
        b.stats[:health] - damage(a.stats[:strength], b.stats[:defense]) <= 0
    end


    def move
        if not easy_targets.empty?
            return [:attack, easy_targets.sample]
        elsif stats[:health] <= MAX_HEALTH
            return [:rest]
        else
            return [:attack, choose_enemey_to_attack(enemies)]
        end
    end

    def easy_targets
        enemies.select {|p| can_kill?(self, p)}
    end

    # Choose the most suitable enemy to attack:
    # - more experienced one (really good AI)
    # - the lowest possible health (attack somebody until one is dead)
    # - minimal defense (they are easier to kill)
    # - bigger strength (more dangeorous)
    def choose_enemey_to_attack(enemies)
        enemies.sort_by { |p| [-p.stats[:experience], p.stats[:health], p.stats[:defense], -p.stats[:strength], ] }.first
    end
end
