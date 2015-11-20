module DirModel
  module Import
    class Path # Csv

      attr_reader :path
      attr_reader :index
      attr_reader :current_path

      def initialize(path)
        @path = path
        reset
      end

      def size
        @size ||= _ruby_path.size
      end

      def reset
        @index = -1
        @current_path = nil
        @ruby_path = _ruby_path
        true
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
        if @next_path
          @current_path = @next_path
          @next_path = nil
          increment_index(@current_path)
        else
          @current_path = _read_path { |path| increment_index(path) }
        end
        current_path
      end

      protected

      def _ruby_path
        Pathname.glob("spec/#{path}/**/*").each
      end

      def _read_path(index=@index, ruby_path=@ruby_path)
        path = ruby_path.next.to_path
        index += 1 if index
        yield path if block_given?
        path
      rescue StopIteration
        set_end
       nil
      end

      def increment_index(current_path)
        current_path.nil? ? set_end : @index += 1
      end

      def set_end
        @current_path = @index = nil
      end

    end
  end
end
