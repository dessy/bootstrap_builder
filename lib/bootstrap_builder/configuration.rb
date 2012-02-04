module BootstrapBuilder
  class Configuration

    # The templates folder 
    attr_accessor :template_folder
        
    # Configuration defaults
    def initialize
      @template_folder = :bootstrap_builder
    end
    
  end
end