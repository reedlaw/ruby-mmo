# # Author: Jack Forrest (jack@jrforrest.net, gh: jrforrest)
# #
# # Changes
# # v0: How do I shot rat?
# # v1: Slaughter rats for that early exp
# # v2: Attack low health players to get some KS going
# # v3: Refactor with some classes, now that I've patched engine.rb
# #     (this better get accepted upstream or I'll have to refactor again...)
# # v4: Attack the leader if you've got nothing else going on
# # v5: Heal often, cause the posse jumps you at the smell o' blood
# # v6: That fool dank has ruined the game for us all.  I tried to mess
# #     with his minions a bit.  He still dominates, but others stand a
# #     chance now.
# # v7: Put the brakes on levelling up to avoid getting ganked early game
# module Jax

#   # Basically a decorator on top of player classes.  Provides some
#   # calculations and simpler accessor methods to make logic elsewhere
#   # less ugly.
#   class PlayerHeuristics
#     attr_reader :player

#     BASE_HEALTH_MAX = 100

#     PlayerAttrs = [:health, :level, :strength, :defense, :experience]

#     # define a pretty acessor for each of PlayerAttrs
#     PlayerAttrs.each do |attr|
#       define_method(attr) { @player.stats[attr] }
#     end

#     # @param [Module] The player module which will be represented
#     #   by this wonderful wrapper object.
#     def initialize(player)
#       @player = player
#     end

#     def name
#       player.to_s
#     end

#     def is_rat?
#       player.to_s == 'rat'
#     end

#     # @note This isn't actually right it turns out, but whatever.
#     def max_health
#       BASE_HEALTH_MAX + (level * 10)
#     end
#   end

#   # Encapsulates strategic decision-making
#   class ProStrats
#     attr_reader :my_player

#     def initialize(this_fuggin_guy)
#       @my_player = PlayerHeuristics.new(this_fuggin_guy)

#       # Get this party started by attempting to screw over dank.
#       dank_you_very_much
#     end

#     # Choose who to attack
#     def pick_victim
#       # If there's a player we can kill we want to get in on that
#       return killable_bots.sample.player unless killable_bots.empty?
#       # Rats seem to be OP in terms of exp reward,
#       # use them if there's not so few that you've gotta share the exp
#       return rats.sample.player unless rats.empty?
#       # If there's not a good victim mind as well attack the leading bot
#       return leading_bot.player
#     end

#     # @return [Array<PlayerHeuristics>] Other bots (not rats) in the
#     #   game which must be vanquished to secure victory
#     def leading_bot
#       other_players.sort{|x, y| y.level <=> x.level}.first
#     end

#     # @return [true, false] Will my player attack or rest this round?
#     def attack?
#       # Winning players tend to get ganked early game, so we need
#       # to stay under the radar experience wise until everyone else is dying
#       # off
#       return false if exp_rank <= 2 and other_players.count >= 7

#       # Heal up if you're in the health danger zone
#       return false if missing_health > 20

#       # If there's a killing to be done do it
#       return true unless rats.empty? and killable_bots.empty?

#       # Might as well heal if there's not a good target
#       return false if missing_health > 0

#       # Might as well attack if there's nothing else to do
#       return true
#     end

#     protected

#     def missing_health
#       my_player.max_health - my_player.health
#     end

#     # @return [Fixnum] The rank (1 is best) of my player amongst the
#     #   other players experience-wise
#     def exp_rank
#       (other_players << my_player).
#         sort {|x, y| y.experience <=> x.experience }.
#         index(my_player) + 1
#     end

#     # @return [Array<PlayerHeuristics>] The other players in the game
#     #   (including rats.)
#     def other_players
#       @other_players ||= Game.world[:players].select{|p| p != my_player}.
#         map{|p| PlayerHeuristics.new(p) }
#     end

#     # @return [Array<PlayerHeuristics>] Other bots which may be one-shotted
#     #   by my player this turn.
#     #
#     # @note
#     #   This misses lots of bots that are currently getting ganked.  Maybe
#     #   I could track the HP of bots over rounds to identify trends to predict
#     #   which bots people are currently ganking, so I can get in on that
#     #   good old fashioned group love.
#     def killable_bots
#       @killable_bots ||= other_players.
#           select {|p| killability_of(p) > 0 and not p.is_rat?}
#     end

#     # @return [Array<PlayerHeuristics>] All the players which are
#     #   delicious rats.
#     def rats
#       @rats ||= other_players.select(&:is_rat?)
#     end

#     # @param [PlayerHeuristics] other_player The player
#     #   which we want to predict damage against
#     #
#     # @return [Fixnum] The damage which will be done if
#     #   {my_player} attacks the given +other_player+
#     def predicted_damage_against(other_player)
#       # Stole from Iz, thxbro!
#       my_player.strength - (other_player.defense / 2)
#     end

#     # @return [Fixnum] A score denoting how killable the given
#     #   other_player is.  The higher the score, the better he dies.
#     #   0 means not killable in this turn.
#     def killability_of(other_player)
#       hp = other_player.health - predicted_damage_against(other_player)
#       return 0 if hp > 0
#       return hp.abs
#     end

#     # Finds players matching the given +name+.  Watch yer cases!
#     #
#     # @param [String] name The name to search for players by.
#     # @return [Array<PlayerHeuristics>] All players with the given name.
#     def find_players(name)
#       other_players.select{|p| p.name == name}
#     end

#     # @return <PlayerHeuristics> So gnar, so heavy, so dank.
#     def real_dank_chron
#       find_players("Dan Knox").first
#     end

#     # Attempts to get dr. dank's minions to attack their dear leader.
#     # Muahaha and all that.
#     #
#     # What the hell is with these minions?  Why is that allowed?  At least
#     # he had the good sense not to cock up my terminal with random control
#     # chars in his name.  (Lookin' at you secure botnet.  Use the /[ -~]/)
#     #
#     # I'm not sure how I feel about this in terms of sportsmanship, but
#     # I think it's a fair response to his tactic.  I'm calling a public
#     # method on his minions, which certainly isn't against the letter
#     # of the rules, but perhaps it's still against the spirit of the game.
#     #
#     # Unfortunately fixing this exploit would be trivial.  Since I can only
#     # send messages to the minions, but not listen to messages sent by other
#     # players, he would just need to utilize a shared authenticity token
#     # generated in his module generation loop where I can't get to it,
#     # and use that to prove authenticity of each message.
#     def dank_you_very_much
#       other_players.each do |minion|
#         if minion.player.respond_to?(:trade)
#           minion.player.trade(:set_target, real_dank_chron.player)
#         end
#       end
#     end
#   end

#   def to_s
#     'Jax'
#   end

#   def move
#     strats = ProStrats.new(self)
#     if strats.attack?
#       return [:attack, strats.pick_victim]
#     else
#       return [:rest]
#     end
#   end
# end
