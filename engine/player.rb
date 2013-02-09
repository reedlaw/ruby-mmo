require 'lspace/celluloid'
class Player
  include Celluloid
  lspace_reader :world

  def world
    LSpace[:world]
  end

  def get_move
    proc {
      $SAFE = 4
      Actor.current.move
    }.call
  end

  def get_name
    proc {
      $SAFE = 4
      Actor.current.name
    }.call
  end
end
