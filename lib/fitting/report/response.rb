require 'fitting/report/combinations'
require 'fitting/report/combination'

module Fitting
  module Report
    class Response
      def initialize(response)
        @response = response
        @id = SecureRandom.hex
        @cover = false
      end

      def cover?
        @cover
      end

      def mark!(test)
        @cover = true
      end

      def status
        @response['status'] || @response[:status]
      end

      def body
        @response['body'] || @response[:body]
      end

      attr_reader :id, :tests

      def combinations
        return @combinations if @combinations

        cmbntns = []
        combinations = Fitting::Cover::JSONSchema.new(body).combi +
                       Fitting::Cover::JSONSchemaEnum.new(body).combi +
                       Fitting::Cover::JSONSchemaOneOf.new(body).combi
        if combinations != []
          combinations.map do |combination|
            cmbntns.push(
              Fitting::Report::Combination.new(
                json_schema: combination[0],
                type: combination[1][0],
                combination: combination[1][1]
              )
            )
          end
        end

        @combinations = Fitting::Report::Combinations.new(cmbntns)
      end
    end
  end
end
