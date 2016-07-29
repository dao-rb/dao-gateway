module Dao
  module Gateway
    class Pipe
      include Enumerable

      def initialize(data, processors, associations)
        @data = data
        @processors = processors
        @associations = associations
        @data_processed = false
      end

      def postprocess(processor)
        @processors << processor
      end

      def preprocess(processor)
        insert_processor_at(0, processor)
      end

      def insert_processor_at(index, processor)
        @processors.insert(index, processor)
      end

      def preprocess_before(processor_type, processor)
        index = @processors.index { |el| el.instance_of? processor_type }
        insert_processor_at(index, processor)
      end

      def processed?
        @data_processed
      end

      def each(&block)
        if processed?
          @data.each(&block)
        else
          process_data(&block)
        end
      end

      def fork
        raise 'Data was already processed' if processed?
        fork!
      end

      def fork!
        self.class.new(@data.dup, @processors.dup, @associations)
      end

      private

      def process_data(&block)
        @data_processed = true
        result = []

        @data.each_with_index do |raw_element, index|
          entity = raw_element

          @processors.all? do |processor|
            entity = processor.process(entity, @associations, raw_element)
            processor.continuable?
          end

          result[index] = entity

          block.call(entity)
        end

        @data = result
      end
    end
  end
end
