require 'lspace/celluloid'
class Player
  include Celluloid
  lspace_reader :world

  def safe_send(method)
    proc {
      $SAFE = 4
      Actor.current.send(method)
    }.call
  end
end
