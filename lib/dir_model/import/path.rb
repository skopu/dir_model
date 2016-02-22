module DirModel
  module Import
    class Path # Csv

      attr_reader :path
      attr_reader :index
      attr_reader :current_path

      def initialize(dir_path)
        @path, @index = dir_path, -1
        reset!
      end

      def size
        @size ||= ruby_path.size
      end

      def reset!
        @index = -1
        @current_path = @ruby_path = nil
      end

      def start?
        index == -1
      end

      def end?
        index.nil?
      end

      def next_path
        ruby_path[index+1]
      end

      def previous_path
        return nil if index < 1
        ruby_path[index-1]
      end

      def read_path
        return if end?
        @index += 1
        @current_path = ruby_path[index]
        set_end unless current_path
        current_path
      end

      def set_position(index)
        @index = index
      end

      def rewind
        set_position(-1)
      end

      protected

      def ruby_path
        @ruby_path ||= ::Dir.glob("#{path}/**/*").sort
      end

      def set_end
        @current_path = @index = nil
      end

    end
  end
end
