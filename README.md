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

The game can be run 1000 times using `./multi_run.rb`

Latest results:

    strax won 295 times
    South Pole Steve won 247 times
    Stealthy Guy won 199 times
    Michael won 124 times
    Izidor won 50 times
    Valentin won 33 times
    Jurek won 31 times
    Raiko won 10 times
    Chuck Norris won 5 times
    Eric the Kill Steal won 5 times
    Kabutomushi won 1 times

Results from April 11, 2012:

    Eric the Kill Steal won 272 times
    strax won 247 times
    A Tabby Cat won 226 times
    Ian Terrell won 185 times
    Valentin won 39 times
    Izidor won 21 times
    *No rest for the wicked* won 10 times

Honorable Mention
-----------------

Jurek wins most of the time in rounds of 1,000.
