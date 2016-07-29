module Dao
  module Gateway
    class Iterator
      include Enumerable

      attr_reader :pipe

      def initialize(data, pipe, associations)
        @data = data
        @pipe = pipe
        @associations = associations
        @data_processed = false
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
        self.class.new(@data.dup, pipe.dup, @associations)
      end

      private

      def process_data(&block)
        @data_processed = true
        result = []

        @data.each_with_index do |raw_element, index|
          entity = pipe.process(raw_element, @associations)

          result[index] = entity

          block.call(entity)
        end

        @data = result
      end
    end
  end
end
