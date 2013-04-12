module Rinit
  module Commands
    class << self
      def get_pid_from_file filename
        begin
          pid = IO.readlines(filename).first
        rescue Errno::ENONET => e
          puts "File: #{filename} does not exist"
        end
        pid
      end

      def start

      end

      def stop

      end

      def status

      end

      def restart

      end

    end
  end
end
