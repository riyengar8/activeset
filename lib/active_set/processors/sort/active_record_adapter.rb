# frozen_string_literal: true

require_relative '../base_adapter'
require_relative '../base_processor'

class ActiveSet
  class SortProcessor < BaseProcessor
    class ActiveRecordAdapter < BaseAdapter
      def process
        return return_set unless @set.respond_to? :to_sql
        return return_set unless attribute_is_field?

        return_set(processed_set)
      end

      private

      def attribute_is_field?
        return false unless attribute_model
        attribute_model.attribute_names
                       .include?(@instruction.attribute)
      end

      def processed_set
        @set.includes(@instruction.associations_hash)
            .references(@instruction.associations_hash)
            .merge(arel_operation)
      end

      def arel_operation
        column = case_insensitive? ? arel_column.lower : arel_column
        attribute_model.order(column.send(@instruction.value))
      end

      def attribute_model
        @instruction.associations_array
                    .reduce(@set.klass) do |obj, assoc|
                      obj.reflections[assoc.to_s]&.klass
                    end
      end

      def arel_column
        arel_table[@instruction.attribute]
      end

      def arel_table
        Arel::Table.new(attribute_model.table_name)
      end

      def case_insensitive?
        @instruction.operator.to_s == 'i'
      end
    end
  end
end
