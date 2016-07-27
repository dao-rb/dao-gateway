module Dao
  module Gateway
    class BlockProcessor < Processor
      def initialize(continuable = true, &block)
        @continuable = continuable
        @processor = block
      end

      def process(*args)
        @processor.call(*args, self)
      end

      def continuable?
        @continuable
      end

      def continuable!
        @continuable = true
      end

      def stop!
        @continuable = false
      end
    end
  end
end
