module DirModel
  module Import
    class Path # Csv

      attr_reader :path
      attr_reader :index
      attr_reader :current_path
      attr_reader :previous_path

      def initialize(path)
        @path = path
        reset!
      end

      def size
        @size ||= ruby_path.size
      end

      def reset!
        @index = -1
        @current_path = @ruby_path = @previous_path = nil
      end

      def start?
        index == -1
      end

      def end?
        index.nil?
      end

      def next_path
        @next_path ||= _read_path
      end

      def read_path
        @previous_path = @current_path
        unless caching_value?
          @current_path = _read_path { forward! }
        end
        current_path
      end

      protected

      def caching_value?
        if @next_path
          @current_path = @next_path
          @next_path = nil
          forward!
          true
        else
          false
        end
      end

      def ruby_path
        @ruby_path ||= Pathname.glob("#{path}/**/*").each
      end

      def _read_path
        path = ruby_path.next.to_path
        yield if block_given?
        path
      rescue StopIteration
        set_end
       nil
      end

      def forward!
        @index += 1
      end

      def set_end
        @current_path = @index = nil
      end

    end
  end
end
