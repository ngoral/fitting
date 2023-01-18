require 'fitting/doc/step'
require 'fitting/cover/json_schema_enum'
require 'fitting/doc/combination_enum'

module Fitting
  class Doc
    class Combination < Step
      class NotFound < RuntimeError; end

      def initialize(json_schema, type, combination)
        @step_cover_size = 0
        @json_schema = json_schema
        @next_steps = []
        @type = type
        @step_key = combination
        combinations = Fitting::Cover::JSONSchemaEnum.new(@json_schema).combi
        if combinations.size > 1
          combinations.each do |comb|
            @next_steps.push(CombinationEnum.new(comb[0], "#{type}.#{comb[1][0]}", "#{combination}.#{comb[1][1]}"))
          end
        end
      end

      def cover!(log)
        if JSON::Validator.fully_validate(@json_schema, log.body) == []
          @step_cover_size += 1
          @next_steps.each { |combination| combination.cover!(log) }
=begin
        else
          raise NotFound.new "combination: #{@combination}\n"\
            "combination type: #{@type}\n"\
            "combination json-schema: #{::JSON.pretty_generate(@json_schema)}\n"\
            "combination error #{::JSON.pretty_generate(JSON::Validator.fully_validate(@json_schema, log.body))}\n"\
            "body: #{::JSON.pretty_generate(log.body)}"
=end
        end
      end

      def mark_range(index, res)
        res[index] = @step_cover_size
        if @json_schema["required"]
          mark_required(index, res, @json_schema)
        end
      end

      def index_offset
        YAML.dump(@json_schema).split("\n").size - 3
      end
    end
  end
end
