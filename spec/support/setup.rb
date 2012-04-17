module GameManager
  class Setup
    def self.require_directory(dirs)
      dirs.each do |dir|
        Dir[File.expand_path("../../../#{dir}/*.rb",__FILE__)].each {|f| require f}
      end
    end
    
    def self.modules
      @modules ||= []
    end
    
    def self.player_modules
      @player_modules ||= []
    end
    
    def self.perform_setup
      require_directory [:engine]
      ObjectSpace.each_object(Module) {|m| modules << m.name }
      require_directory [:players]
      ObjectSpace.each_object(Module) do |m| 
        player_modules << m unless modules.include?(m.name)
      end
      require_directory [:monsters]
    end
  end
end