module Dao
  module Gateway
    class EntityProcessor < Processor
      def initialize(entity_class)
        @entity_class = entity_class
      end

      def process(attributes, associations, *)
        @entity_class.new(attributes).tap do |entity|
          entity.initialized_with = associations
        end
      end
    end
  end
end
