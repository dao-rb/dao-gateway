module Dao
  module Gateway
    class ScopeTransformer
      attr_reader :entity
      attr_accessor :associations

      def initialize(entity)
        @associations = []
        @entity = entity
        @processors = [Dao::Gateway::EntityProcessor.new(entity)]

        add_processors
      end

      def many(relation)
        transform(relation)
      end

      def one(relation)
        transform(relation).first
      end

      def other(relation)
        relation
      end

      def export_attributes_black_list
        []
      end

      protected

      def transform(relation)
        Pipe.new(relation, @processors, @associations)
      end

      def add_processors

      end
    end
  end
end

