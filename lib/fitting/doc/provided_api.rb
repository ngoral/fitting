module Fitting
  class Doc
    class ProvidedAPI
      class Skip < RuntimeError; end

      class NotFound < RuntimeError; end

      attr_accessor :prefix, :path

      def initialize(path, prefix)
        @path = path
        @prefix = prefix
      end

      def self.all(yaml)
        yaml['ProvidedAPIs'].map do |host|
          new(host['path'], host['prefix'])
        end
      end

      def host
        'www.example.com'
      end

      def self.find!(docs, log)
        new
      end

      def actions
      end

      def cover!
      end
    end
  end
end
