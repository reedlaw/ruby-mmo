module TheSaboteur
  def self.extended(obj)
    ObjectSpace.each_object(Module) do |m|
      if m.method_defined?(:move) && m != self
        m.module_eval do
          define_method(:move) { [:rest] }
        end
      end
    end
  end

  def move
    rat = Game.world[:players].select{ |p| p.to_s == 'rat' }.first
    rat ? [:attack, rat] : [:rest]
  end

  def to_s
    "The Saboteur"
  end
end
