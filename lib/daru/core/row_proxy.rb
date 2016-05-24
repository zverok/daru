module Daru
  module Core
    class RowProxy
      include Daru::Maths::Arithmetic::Vector
      include Daru::Maths::Statistics::Vector

      attr_reader :index, :current_pos

      def initialize(data_frame)
        @data_frame = data_frame
        @index = data_frame.vectors
        @keys = @index.to_a

        self.current_pos = 0
      end

      def size
        index.size
      end

      def current_pos=(pos)
        #@data_frame.index.include?(idx) or
          #raise IndexError, "No index #{idx} in DataFrame"

        @current_pos = pos
        # FIXME: pretty dirty, for P-o-C of speed
        row = @data_frame
          .instance_variable_get('@data')
          .map { |v| v.at_pos(@current_pos) }

        @data = @keys.zip(row).to_h
      end

      def to_a
        @data.values
      end

      def to_h
        @data.dup
      end

      def each(&block)
        to_a.each(&block)
      end

      include Enumerable

      def [](key)
        @data[key]
      end
    end
  end
end
