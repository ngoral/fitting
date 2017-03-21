require 'fitting/route/coverage'
require 'fitting/route/requests'
require 'fitting/route/responses'

module Fitting
  class Route
    def initialize(all_responses, routes)
      coverage = Fitting::Route::Coverage.new(all_responses, routes)
      @requests = Fitting::Route::Requests.new(coverage)
      @responses = Fitting::Route::Responses.new(routes, coverage)
    end

    def statistics
      [@requests.statistics, @responses.statistics].join("\n\n")
    end

    def statistics_with_conformity_lists
      [@requests.conformity_lists, statistics].join("\n\n")
    end
  end
end