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

Winners
-------

### Sprint (`./multi_run.rb -r 1000 -o 10`)

    Jbttn won 388 times
    Valentin won 251 times
    *noob* won 100 times
    strax won 73 times
    Angry Mamay won 64 times
    Izidor won 37 times
    Lachesis won 26 times
    Clotho won 18 times
    Atropos won 18 times
    Jax won 16 times
    __pwned_clone_left won 4 times
    Van Diagram won 3 times
    Z Cloud Strife won 1 times
    limekin won 1 times

### Race (`./multi_run.rb -r 1000 -o 100`)

    Chuck Norris won 181 times
    __pwned won 90 times
    flipback won 82 times
    Eric the Kill Steal won 76 times
    Atropos won 66 times
    __pwned_clone_right won 65 times
    Z Cloud Strife won 61 times
    Jax won 47 times
    Clotho won 47 times
    __pwned_clone_left won 42 times
    Emmanuel, the new guy won 42 times
    Lachesis won 39 times
    Van Diagram won 37 times
    Izidor won 37 times
    strax won 13 times
    | Drowsy Leo | won 12 times
    Rogue Leader won 12 times
    limekin won 11 times
    Michael won 7 times
    *noob* won 5 times
    rots won 5 times
    *No rest for the wicked* won 4 times
    Angry Mamay won 4 times
    Ian Terrell won 3 times
    Cossack Mamay won 3 times
    Jayaram won 2 times
    Teeler won 2 times
    Jack won 2 times
    South Pole Steve won 1 times
    A Tabby Cat won 1 times
    Sir Samsonite won 1 times

### Endurance (`./multi_run.rb -r 1000 -o 1000`)

    Chuck Norris won 158 times
    Eric the Kill Steal won 123 times
    Z Cloud Strife won 118 times
    Lachesis won 69 times
    Atropos won 66 times
    flipback won 66 times
    __pwned won 53 times
    __pwned_clone_right won 47 times
    Clotho won 39 times
    Emmanuel, the new guy won 39 times
    __pwned_clone_left won 32 times
    Van Diagram won 32 times
    Izidor won 29 times
    Jax won 22 times
    Michael won 18 times
    | Drowsy Leo | won 15 times
    limekin won 15 times
    Ian Terrell won 10 times
    Rogue Leader won 10 times
    *No rest for the wicked* won 8 times
    Angry Mamay won 5 times
    strax won 4 times
    rots won 4 times
    *noob* won 4 times
    Sir Samsonite won 3 times
    Teeler won 3 times
    Jack won 2 times
    Dan Knox won 1 times
    Crazy Carl won 1 times
    Jayaram won 1 times
    Cossack Mamay won 1 times
    South Pole Steve won 1 times
    A Tabby Cat won 1 times
