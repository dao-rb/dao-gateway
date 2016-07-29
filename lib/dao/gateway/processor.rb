module Dao
  module Gateway
    class Processor
      def prepare(associations, raw_record)
        @associations = associations
        @raw_record = raw_record
        prepared
      end

      def process(attributes)
        attributes
      end

      def need_to_continue_lookup?
        true
      end

      protected

      def prepared

      end
    end
  end
end
