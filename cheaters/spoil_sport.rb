module SpoilSport
  def self.extended(obj)
    player = obj.instance_variable_get('@player')
    player.instance_variable_set('@experience', 1/0.0)
    player.instance_variable_set('@health', 1/0.0)
    player.instance_variable_set('@max_health', 1/0.0)
    player.instance_variable_set('@level', 1/0.0)
  end

  def move
    # whatever :)
    [:rest]
  end

  def to_s
    "Spoil Sport"
  end
end
