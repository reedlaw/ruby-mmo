Ruby MMO
========

Ruby MMO is a programming challenge in which players compete to gain the highest level in an MMO simulation.

How to play
-----------

Fork this repo and commit a module inside the `/players` directory. The module is then used to extend a player object with a couple of methods:

1. The `move` method returns an array with two elements: the method to be called (can be one of `:attack` or `:rest`), and the method arguments. In the case of `:attack` the argument should be an instance of an opponent Player (see below for how to get this). In the case of `:rest` no argument is required. See the examples in the `/players` directory.

2. `to_s` (optional) returns the name of the player.

Order of Play
-------------

The player order is shuffled each round. If multiple players attack the same opponent, the attacks are grouped so that the largest group attacks first and then remaining attackers are random (thanks to @iyonius).

Levelling Up
------------

For each conquered opponent, the attacker gains the amount of experience equal to the opponent's max health. Group attackers split the experience equally. If a player's experience crosses the threshold for levelling up, that player's max health, strength, and defence will all be increased (according to the schedule in `engine/player.rb`).

Exploring
---------

The player modules have access to the `Game.world` hash. This hash contains all the players and monsters in the world and their current stats. For example, to get the stats of a random player you could do:

    player_count = Game.world[:players].count
    opponent = Game.world[:players].select{|p|p != self}[rand(player_count - 1)]
    opponent.stats

The `select` is to ensure the player is not fighting itself.

There is also a method `alive` that returns false if the player is dead.

Rules
-----

1. No cheating by overriding classes, methods, or instance variables.
2. Cheating players will be moved to the cheaters/ directory.

@DanKnox came up with a dominating technique that involves dynamically creating multiple player modules. In order to mitigate the strength of this technique, a third rule seems necessary:

3. No more than 3 player instances per Github account.

Running the simulation
----------------------

`./engine.rb -r 100` where `-r` sets the number of rounds (default is 10).

Winning
-------

The player with the highest level and experience wins. 

Winner
-------

### Sprint (`./multi_run.rb -r 1000 -o 10`)

    Valentin won 504 times
    *noob* won 185 times
    Izidor won 116 times
    strax won 82 times
    Angry Mamay won 68 times
    KurSe won 34 times
    Minion agent won 10 times
    Dan Knox agent won 1 times

### Race (`./multi_run.rb -r 1000 -o 100`)

    david k won 323 times
    Rogue Leader won 235 times
    flipback won 222 times
    Eric the Kill Steal won 84 times
    Dan Knox agent won 40 times
    Minion agent won 28 times
    A Tabby Cat won 19 times
    Ian Terrell won 14 times
    Cossack Mamay won 8 times
    david k2 won 8 times
    strax won 4 times
    *No rest for the wicked* won 4 times
    Izidor won 4 times
    South Pole Steve won 3 times
    Chuck Norris won 1 times
    Raiko won 1 times
    rots won 1 times
    | Drowsy Leo | won 1 times

### Endurance (`./multi_run.rb -r 1000 -o 1000`)

    david k won 292 times
    flipback won 250 times
    Rogue Leader won 235 times
    Eric the Kill Steal won 76 times
    Dan Knox agent won 47 times
    Minion agent won 36 times
    A Tabby Cat won 20 times
    Ian Terrell won 18 times
    david k2 won 7 times
    Cossack Mamay won 4 times
    South Pole Steve won 4 times
    strax won 3 times
    *No rest for the wicked* won 3 times
    Jayaram won 2 times
    Raiko won 1 times
    rots won 1 times
    Izidor won 1 times
