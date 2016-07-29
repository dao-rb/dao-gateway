module Dao
  module Gateway
    class ScopeTransformer
      attr_reader :entity
      attr_reader :pipe
      attr_accessor :associations

      def initialize(entity)
        @associations = []
        @entity = entity

        @pipe = Pipe.new
        @pipe.postprocess(Dao::Gateway::EntityProcessor.new(entity))

        add_processors
      end

      def many(relation)
        transform(relation)
      end

      def one(relation)
        transform(Array(relation)).first
      end

      def other(relation)
        relation
      end

      def export_attributes_black_list
        []
      end

      protected

      def transform(relation)
        Iterator.new(relation, pipe, @associations)
      end

      def add_processors

      end
    end
  end
end

