module Dao
  module Gateway
    class BlockProcessor < Processor
      def initialize(need_to_continue_lookup = true, &block)
        @original_need_to_continue_lookup = need_to_continue_lookup
        @processor = block
      end

      def prepared
        @need_to_continue_lookup = @original_need_to_continue_lookup
      end

      def need_to_continue_lookup?
        @need_to_continue_lookup
      end

      def process(entity)
        @processor.call(entity, @associations, @raw_record, self)
      end

      def need_to_continue_lookup!
        @need_to_continue_lookup = true
      end

      def stop!
        @need_to_continue_lookup = false
      end
    end
  end
end
