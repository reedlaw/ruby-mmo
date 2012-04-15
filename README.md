Ruby MMO
========

Ruby MMO is a programming challenge in which players compete to gain the highest level in an MMO simulation.

How to play
-----------

Fork this repo and commit a module inside the `/players` directory. The module is then used to extend a player object with a couple of methods:

1. The `move` method returns an array with two elements: the method to be called (can be one of `:attack` or `:rest`), and the method arguments. In the case of `:attack` the argument should be an instance of an opponent Player (see below for how to get this). In the case of `:rest` no argument is required. See the examples in the `/players` directory.

2. `to_s` (optional) returns the name of the player.

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

Running the simulation
----------------------

`./engine.rb -r 100` where `-r` sets the number of rounds (default is 10).

Winning
-------

The player with the highest level and experience wins. 

Winners
-------

### Sprint (`./multi_run.rb -r 1000 -o 10`)

    Jayaram won 522 times
    Mighty Snuderl won 288 times
    Valentin won 67 times
    *noob* won 41 times
    Jack won 31 times
    strax won 22 times
    Angry Mamay won 16 times
    Izidor won 7 times
    South Pole Steve won 5 times
    Kabutomushi won 1 times

### Race (`./multi_run.rb -r 1000 -o 100`)

    Cossack Mamay won 470 times
    Chuck Norris won 156 times
    South Pole Steve won 112 times
    *noob* won 101 times
    Kabutomushi won 66 times
    Angry Mamay won 29 times
    Mighty Snuderl won 28 times
    Michael won 13 times
    Izidor won 13 times
    Jack won 6 times
    Eric the Kill Steal won 5 times
    Jayaram won 1 times

### Endurance (`./multi_run.rb -r 10 -o 1000`)

    Cossack Mamay won 429 times
    Chuck Norris won 172 times
    *noob* won 104 times
    South Pole Steve won 102 times
    Kabutomushi won 70 times
    Michael won 28 times
    Angry Mamay won 27 times
    Mighty Snuderl won 25 times
    Eric the Kill Steal won 13 times
    Izidor won 13 times
    Jack won 8 times
    Sir Samsonite won 6 times
    Crazy Carl won 1 times
    jimworm won 1 times
    Jayaram won 1 times
