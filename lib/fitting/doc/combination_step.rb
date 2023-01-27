require 'fitting/doc/step'

module Fitting
  class Doc
    class CombinationStep < Step
      def debug_report(index)
        combinations = []
        @next_steps.each do |next_step|
          combinations.push(
            next_step.debug_report(index)
          )
        end
        {
          "combination type" => @type,
          "combination" => @step_key,
          "json_schema" => @json_schema,
          "valid_jsons" => @logs,
          "index_before" => @index_before - index,
          "index_medium" => @index_medium - index,
          "index_after" => @index_after - index,
          "res_before" => @res_before.map{|r| r ? r : "null"}[index..-1],
          "res_medium" => @res_medium.map{|r| r ? r : "null"}[index..-1],
          "res_after" => @res_after.map{|r| r ? r : "null"}[index..-1],
          "combinations" => combinations
        }
      end
    end
  end
end
