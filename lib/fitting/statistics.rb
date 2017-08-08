require 'fitting/storage/white_list'
require 'fitting/storage/documentation'
require 'fitting/records/documented'
require 'fitting/statistics/analysis'
require 'fitting/statistics/measurement'

module Fitting
  class Statistics
    def initialize(tested)
      @tested = tested
    end

    def save
      FileUtils.mkdir_p 'fitting'
      File.open('fitting/stats', 'w') { |file| file.write(stats) }
      File.open('fitting/not_covered', 'w') { |file| file.write(not_covered) }
    end

    def stats
      if documented.requests.to_a.size > documented.requests.white.size
        [
          ['[Black list]', black_statistics.all].join("\n"),
          ['[White list]', white_statistics.all].join("\n"),
          ''
        ].join("\n\n")
      else
        [white_statistics.all, "\n\n"].join
      end
    end

    def not_covered
      Fitting::Statistics::NotCoveredResponses.new(white_measurement).to_s
    end

    def documented
      return @documented if @documented

      @documented = Fitting::Records::Documented.new(
        Fitting::Storage::Documentation.tomogram.to_hash
      )
      @documented.joind_white_list(white_list)
      @documented.join(@tested)
      @documented
    end

    def white_statistics
      @white_statistics ||= Fitting::Statistics::Analysis.new(white_measurement)
    end

    def black_statistics
      @black_statistics ||= Fitting::Statistics::Analysis.new(black_measurement)
    end

    def white_measurement
      @white_measurement ||= Fitting::Statistics::Measurement.new(documented.requests.white)
    end

    def black_measurement
      @black_measurement ||= Fitting::Statistics::Measurement.new(documented.requests.black)
    end

    def white_list
      Fitting::Storage::WhiteList.new(
        Fitting.configuration.white_list,
        Fitting.configuration.resource_white_list,
        Fitting::Storage::Documentation.tomogram.to_resources
      ).to_a
    end
  end
end
