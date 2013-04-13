require 'sys/proctable'

module Rinit
  class << self
    include Sys
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

    def status ppid
      status = "stopped"
      ProcTable.ps{ |p|
        if p.pid == ppid
          status = "running"
        end
      }
      status
    end

    def restart

    end

  end
end
