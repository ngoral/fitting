require 'fitting/version'
require 'fitting/documentation'
require 'fitting/configuration'

module Fitting
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end

module ActionController
  class TestCase
    module Behavior
      alias origin_process process

      def process(action, *args)
        response = origin_process(action, *args)
        Fitting::Documentation.try_on(self, request, response)
        response
      end
    end
  end
end
