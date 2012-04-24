(0..2).each do |n|
  eval %(
    module Dank#{n}
      BOSS_DANGER_ZONE = 90
      MINION_DANGER_ZONE = 80
      ATTACKER_POOL = 5
      CAUTIOUS_ROUNDS = 20
      RISKY_ROUNDS = 50
      
      def self.extended(base)
        base.instance_variable_set :@round_count, 0
      end
      
      def to_s
        minion? ? "Minion" : "Dan Knox"
      end
  
      def move
        @round_count += 1
        prepare_friendlies if game_is_beginning?
        promote_minion if boss_lacks_experience? || boss_dead?
        minion? ? rest_or_attack : command_and_control
      end
      
      def trade(command,target=nil)
        case command
        when :begin_game
          @minion = true
          @game_underway = true
        when :set_target
          @target = target
        when :set_boss
          @minion = false
        when :set_super_secret_code
          @super_secret_code = target
        end
      end      
      
      protected
      
      def rest_or_attack
        @target = available_monsters.sample if @target.nil?
        if @round_count < CAUTIOUS_ROUNDS
          @target = available_monsters.sample if available_monsters.any?
          return [:rest] unless (@round_count % 2 == 0)
        end
        dangerous_health? ? [:rest] : [:attack,@target]
      end

      def command_and_control
        ensure_only_one_boss
        @target = @next_target
        set_attack_targets
        rest_or_attack
      end

      def set_attack_targets
        @current_friends = friends
        attackers = ATTACKER_POOL
  
        (friends + secure_bots).each_with_index do |friend,index|
          if @round_count > RISKY_ROUNDS && secure_bots.any?
            new_target = secure_bots.first
          else
            new_target = index <= attackers ? strongest_enemies[0] : strongest_enemies[1]
          end
          if friend.respond_to?(:iff)
            friend.set_target( @super_secret_code, 0, new_target )
          else
            friend.trade( :set_target, new_target )
          end
        end
  
        @next_target = strongest_enemies[0] || friends.first # Everyone else is dead... start giving more experience to the boss
      end

      def aggregrate_strength
        @current_friends.inject(0) { |sum,friend| sum + friend.stats[:strength] }
      end

      def dangerous_health?
        boss? ? 
          (stats[:health] <= BOSS_DANGER_ZONE) :
          (stats[:health] <= MINION_DANGER_ZONE)
      end

      def target_set?
        @target
      end

      def promote_minion
        if most_experienced_minion.nil?
          @minion = false
        else
          @minion = true
          most_experienced_minion.trade(:set_boss)
        end
      end

      def boss_lacks_experience?
        potential_boss = most_experienced_minion || (return false)
        return false unless potential_boss.respond_to?(:stats)
        stats[:experience] < potential_boss.stats[:experience]
      end

      def prepare_friendlies
        @game_underway = true
        @minion = false
        @super_secret_code = discover_secure_bot_secret_code
        friends.each do |friend|
          friend.trade :set_super_secret_code, @super_secret_code
          friend.trade :begin_game
        end
      end
      
      def discover_secure_bot_secret_code
        discovery_bot = secure_bots.first
        initial_target = enemies.first
        secret_code = nil
        (0..1_000_000).map do |possible_key|
          success = discovery_bot.set_target( possible_key, 0, initial_target )
          if success
            secret_code = possible_key
            break
          end
        end
        secret_code
      end
      
      def friends
        Game.world[:players].select { |p| p.to_s =~ /(Minion|Dan Knox)/ && p != self }
      end
      
      def secure_bots
        Game.world[:players].select { |p| p.respond_to?(:iff) && p.alive }
      end
      
      def enemies
        Game.world[:players].select { |p| p.alive }.reject { |p| friends.include?(p) or p == self }
      end

      def strongest_enemies
        enemies.sort { |a,b| b.stats[:experience] <=> a.stats[:experience] }
      end

      def most_experienced_minion
        friends.sort_by { |m| m.stats[:experience] }.last
      end

      def available_monsters
        Game.world[:players].select { |player| monsters.include?(player.to_s) && player.alive }
      end
      
      def boss_dead?
        boss = Game.world[:players].select { |p| p.to_s =~ /Dan Knox/ && p.alive }.first
        boss.nil?
      end
      
      def monsters
        ["rat"]
      end

      def minion?
        @minion
      end

      def boss?
        !@minion
      end

      def game_is_beginning?
        !@game_underway
      end
    end
  )
end
