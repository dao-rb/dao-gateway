module Dao
  module Gateway
    class InvalidRecord < StandardError
      attr_reader :errors

      def initialize(errors)
        super 'Invalid parameters'
        @errors = errors
      end
    end
  end
end
