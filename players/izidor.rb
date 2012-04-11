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
        if can_somebody_kill_me?
            my_enemies = who_can_kill_me

            # If I can kill him, just kill him and save myself
            if my_enemies.size == 1 && can_kill?(self, my_enemies.first)
                return [:attack, my_enemies.first]
            end

            # can prevent them to kill me?
            if would_rest_save_before_killing? my_enemies
                return [:rest]
            end

            # Kamikadze, fight!!!!
            return [:attack, choose_enemey_to_attack(my_enemies)]
        end

        if has_hp_to_survive_total_attack?
            return [:attack, choose_enemey_to_attack(enemies)]
        else
            return [:rest]
        end
    end

    # Enemies who put me in danger and can kill me this turn
    def who_can_kill_me
        enemies.select {|p| can_kill?(p, self)}
    end

    # Choose the most suitable enemy to attack:
    # - the lowest possible health (attack somebody until one is dead)
    # - more experienced one (really good AI)
    # - minimal defense (they are easier to kill)
    # - bigger strength (more dangeorous)
    def choose_enemey_to_attack(enemies)
        enemies.sort_by { |p| [p.stats[:health], p.stats[:experince], p.stats[:defense], p.stats[:strength], ] }.first
    end

    # If I take a rest, could they kill me?
    def would_rest_save_before_killing?(enemies)
        max_strength = enemies.map{ |p| p.stats[:strength] }.max
        health_after_rest - (max_strength - stats[:defense]/2) > 0
    end

    # If every enemy is going to attack me this turn, can I survive them?
    #
    # Return yes if:
    #  - current HP is enough
    #  - resting would hit MAX_HEALTH
    def has_hp_to_survive_total_attack?
        needed_health = enemies.map{ |p| p.stats[:strength] - stats[:defense]/2 }.inject(0) { |sum, x| sum +x }
        needed_health < stats[:health] || health_after_rest() > MAX_HEALTH
    end

end
