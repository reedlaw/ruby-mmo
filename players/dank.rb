(0..2).each do |n|
  eval %(
    module Dank#{n}
      BOSS_DANGER_ZONE = 90
      MINION_DANGER_ZONE = 20
      ATTACKER_POOL = 5
      
      def to_s
        minion? ? "Minion" : "Dan Knox"
      end
  
      def move
        prepare_friendlies if game_is_beginning?
        promote_minion if boss_lacks_experience?
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
        end
      end      
      
      protected
      
      def rest_or_attack
        @target = available_monsters.sample if @target.nil?
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
  
        friends.each_with_index do |friend,index|
          new_target = index <= attackers ? strongest_enemies[0] : strongest_enemies[1]
          friend.trade( :set_target, new_target )
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
        @minion = true
        most_experienced_minion.trade(:set_boss)
      end

      def boss_lacks_experience?
        stats[:experience] < most_experienced_minion.stats[:experience]
      end

      def prepare_friendlies
        @minion = false
        friends.each do |friend|
          friend.trade(:begin_game)
        end
      end

      def friends
        Game.world[:players].select { |p| p.to_s =~ /(Minion|Dan Knox)/ && p != self }
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
