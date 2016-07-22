module Dao
  module Gateway
    class Processor
      def process(attributes, _associations, _raw_record)
        attributes
      end

      def continuable?
        true
      end
    end
  end
end
