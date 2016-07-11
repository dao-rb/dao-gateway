module Dao
  module Gateway
    class ScopeTransformer
      attr_reader :entity
      attr_accessor :associations

      def initialize(entity)
        @entity = entity
        @associations = []
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

      def transform(relation, &block)
        relation.collect do |attributes|
          attributes = block.call(attributes) if block_given?
          @entity.new(attributes).tap do |entity|
            entity.initialized_with = associations
          end
        end
      end
    end
  end
end

