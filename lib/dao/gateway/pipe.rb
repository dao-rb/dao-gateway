module Dao
  module Gateway
    class Pipe
      include Enumerable

      attr_reader :processors

      def initialize
        @processors = []
      end

      def initialize_copy(originial_pipe)
        @processors = originial_pipe.processors.dup
      end

      def postprocess(processor)
        @processors.unshift(processor)
      end

      def preprocess(processor)
        @processors << processor
      end

      def insert_processor_at(index, processor)
        @processors.insert(index, processor)
      end

      def preprocess_before(processor_type, processor)
        index = @processors.index { |el| el.instance_of? processor_type }
        insert_processor_at(index, processor)
      end

      def process(raw_element, associations)
        @data_processed = true

        processors = []

        @processors.all? do |processor|
          processor.prepare(associations, raw_element)

          processors.unshift(processor)

          processor.need_to_continue_lookup?
        end

        processors.inject(raw_element) do |entity, processor|
          processor.process(entity)
        end
      end
    end
  end
end
