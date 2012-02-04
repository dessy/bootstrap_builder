require 'bootstrap_builder/engine' if defined?(Rails)
require 'bootstrap_builder/builder'
require 'bootstrap_builder/helper'
require 'bootstrap_builder/configuration'

module BootstrapBuilder
  class << self

    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
    alias :config :configuration

  end
end

