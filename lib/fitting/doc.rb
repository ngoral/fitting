require 'fitting/doc/action'

module Fitting
  class Doc
    class NotFound < RuntimeError; end

    def self.all(yaml)
      {
        provided: Fitting::Doc::Action.provided_all(yaml['ProvidedAPIs']),
        used: Fitting::Doc::Action.used_all(yaml['UsedAPIs'])
      }
    end

    def self.cover!(docs, log)
      if log.type == 'incoming'
        docs[:provided].each do |doc|
          return if doc.cover!(log)
        end
      elsif log.type == 'outgoing'
        docs[:used].each do |doc|
          return if doc.cover!(log)
        end
      end
      raise NotFound.new "log type: #{log.type}\n\n#{log.method} #{log.url} #{log.status} #{log.type}"
    rescue Fitting::Doc::Action::NotFound => e
      raise NotFound.new "log type: #{log.type}\n\n"\
          "#{e.message}"
    end
  end
end
